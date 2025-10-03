import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_archive/flutter_archive.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart' as sqlite;

import '../entities.dart';
import '../repositories.dart';
import 'exceptions.dart';
import 'import_models.dart';
import 'manifest_schema.dart';
import 'verse_record_validator.dart';

class ImportBiblePackageUseCase {
  ImportBiblePackageUseCase(this._repository);

  final BibleRepository _repository;

  Future<BibleTranslation> call({
    required File packageFile,
    ImportConflictResolution conflictResolution = ImportConflictResolution.prompt,
    void Function(ImportProgress progress)? onProgress,
  }) async {
    _emit(
      onProgress,
      ImportProgress(
        stage: ImportStage.preparing,
        message: 'Preparing ${p.basename(packageFile.path)} for import',
      ),
    );

    if (!await packageFile.exists()) {
      throw BibleImportException('Package file not found at ${packageFile.path}.');
    }

    final tempDir = await Directory.systemTemp.createTemp('bible_package_');
    try {
      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.extracting, message: 'Extracting package...'),
      );
      await ZipFile.extractToDirectory(
        zipFile: packageFile,
        destinationDir: tempDir,
        allowWrite: true,
      );

      final manifestFile = File(p.join(tempDir.path, 'manifest.json'));
      if (!await manifestFile.exists()) {
        throw MissingManifestException();
      }

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.readingManifest, message: 'Reading manifest...'),
      );
      final manifestMap = _decodeJson(await manifestFile.readAsString());

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.validatingManifest, message: 'Validating manifest...'),
      );
      final manifest = BiblePackageManifest.fromJson(manifestMap);

      final existing = await _repository.findTranslationById(manifest.id);
      if (existing != null) {
        switch (conflictResolution) {
          case ImportConflictResolution.prompt:
            throw DuplicateTranslationException(existing: existing, manifest: manifest);
          case ImportConflictResolution.skip:
            return existing;
          case ImportConflictResolution.replace:
            break;
        }
      }

      final payloadFile = _resolvePayloadFile(tempDir, manifest);

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.verifyingChecksum, message: 'Verifying checksum...'),
      );
      final checksum = await _computeChecksum(payloadFile);
      if (checksum.toLowerCase() != manifest.checksum.toLowerCase()) {
        throw ChecksumMismatchException(expected: manifest.checksum, actual: checksum);
      }

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.parsingContent, message: 'Parsing verses...'),
      );
      final verses = await _parsePayload(
        manifest: manifest,
        file: payloadFile,
        onProgress: onProgress,
      );

      final translation = BibleTranslation(
        id: manifest.id,
        name: manifest.name,
        language: manifest.language,
        languageName: _deriveLanguageName(manifest.language),
        version: manifest.version,
        source: manifest.source ?? 'imported',
        copyright: manifest.source ?? '',
        installedAt: DateTime.now(),
      );

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.writingMetadata, message: 'Registering translation metadata...'),
      );
      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.writingVerses, message: 'Writing ${verses.length} verses...'),
      );
      await _repository.saveImportedTranslation(
        translation,
        verses,
        replaceExisting: existing != null &&
            conflictResolution == ImportConflictResolution.replace,
      );

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.buildingSearchIndex, message: 'Building search index...'),
      );
      await _repository.buildSearchIndex(translation.id);

      _emit(
        onProgress,
        ImportProgress(stage: ImportStage.completed, message: 'Import completed.'),
      );

      return translation;
    } on BibleImportException {
      rethrow;
    } catch (error) {
      throw BibleImportException('Failed to import package: $error');
    } finally {
      if (await tempDir.exists()) {
        await tempDir.delete(recursive: true);
      }
    }
  }

  Map<String, dynamic> _decodeJson(String source) {
    final dynamic decoded = jsonDecode(source);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    throw InvalidManifestException(['Manifest root must be a JSON object.']);
  }

  File _resolvePayloadFile(Directory directory, BiblePackageManifest manifest) {
    final candidates = [
      ...manifest.files,
      if (manifest.fileFormat == BiblePackageFileFormat.jsonl) 'verses.jsonl',
      if (manifest.fileFormat == BiblePackageFileFormat.sqlite) 'verses.sqlite',
    ];

    for (final candidate in candidates) {
      if (candidate.trim().isEmpty) {
        continue;
      }
      final file = File(p.join(directory.path, candidate));
      if (file.existsSync()) {
        return file;
      }
    }

    final fallback = candidates.isNotEmpty
        ? candidates.first
        : manifest.fileFormat == BiblePackageFileFormat.jsonl
            ? 'verses.jsonl'
            : 'verses.sqlite';
    throw MissingPackageFileException(fallback);
  }

  Future<String> _computeChecksum(File file) async {
    final sink = crypto.AccumulatorSink<crypto.Digest>();
    final input = crypto.sha256.startChunkedConversion(sink);
    final stream = file.openRead();
    await for (final chunk in stream) {
      input.add(chunk);
    }
    input.close();
    return sink.events.single.toString();
  }

  Future<List<BibleVerse>> _parsePayload({
    required BiblePackageManifest manifest,
    required File file,
    void Function(ImportProgress progress)? onProgress,
  }) async {
    switch (manifest.fileFormat) {
      case BiblePackageFileFormat.jsonl:
        return _parseJsonLines(manifest, file, onProgress);
      case BiblePackageFileFormat.sqlite:
        return _parseSqlite(manifest, file, onProgress);
    }
  }

  Future<List<BibleVerse>> _parseJsonLines(
    BiblePackageManifest manifest,
    File file,
    void Function(ImportProgress progress)? onProgress,
  ) async {
    final verses = <BibleVerse>[];
    var processed = 0;
    final lines = file
        .openRead()
        .transform(utf8.decoder)
        .transform(const LineSplitter());

    await for (final line in lines) {
      if (line.trim().isEmpty) {
        continue;
      }
      Map<String, dynamic> record;
      try {
        record = jsonDecode(line) as Map<String, dynamic>;
      } catch (error) {
        throw BibleImportException('Failed to decode verse JSON: $error');
      }
      final issues = VerseRecordValidator.validate(record);
      if (issues.isNotEmpty) {
        throw BibleImportException(
          'Invalid verse record at index $processed: ${issues.join('; ')}',
        );
      }
      verses.add(
        BibleVerse(
          translationId: manifest.id,
          bookId: record['bookId'] as int,
          chapter: record['chapter'] as int,
          verse: record['verse'] as int,
          text: record['text'] as String,
        ),
      );
      processed++;
      if (processed % 1000 == 0) {
        _emit(
          onProgress,
          ImportProgress(
            stage: ImportStage.parsingContent,
            message: 'Parsed $processed verses...',
          ),
        );
      }
    }

    return verses;
  }

  Future<List<BibleVerse>> _parseSqlite(
    BiblePackageManifest manifest,
    File file,
    void Function(ImportProgress progress)? onProgress,
  ) async {
    final database = sqlite.sqlite3.open(file.path);
    try {
      final result = database.select(
        'SELECT book_id, chapter, verse, text FROM verses ORDER BY book_id, chapter, verse',
      );
      final verses = <BibleVerse>[];
      var processed = 0;
      for (final row in result) {
        final bookId = (row['book_id'] ?? row['bookId']) as int?;
        final chapter = row['chapter'] as int?;
        final verse = row['verse'] as int?;
        final text = row['text'] as String?;
        if (bookId == null || chapter == null || verse == null || text == null) {
          throw BibleImportException(
            'SQLite package must provide book_id, chapter, verse and text columns.',
          );
        }
        verses.add(
          BibleVerse(
            translationId: manifest.id,
            bookId: bookId,
            chapter: chapter,
            verse: verse,
            text: text,
          ),
        );
        processed++;
        if (processed % 1000 == 0) {
          _emit(
            onProgress,
            ImportProgress(
              stage: ImportStage.parsingContent,
              message: 'Parsed $processed verses...',
            ),
          );
        }
      }
      return verses;
    } on sqlite.SqliteException catch (error) {
      throw BibleImportException('Failed to read SQLite payload: ${error.message}');
    } finally {
      database.dispose();
    }
  }

  void _emit(
    void Function(ImportProgress progress)? onProgress,
    ImportProgress progress,
  ) {
    if (onProgress != null) {
      onProgress(progress);
    }
  }

  String _deriveLanguageName(String language) {
    if (language.trim().isEmpty) {
      return language;
    }
    final segments = language.split(RegExp(r'[-_]'));
    return segments
        .where((segment) => segment.isNotEmpty)
        .map(
          (segment) => segment[0].toUpperCase() + segment.substring(1).toLowerCase(),
        )
        .join(' ');
  }
}
