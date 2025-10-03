import '../entities.dart';
import 'manifest_schema.dart';

class BibleImportException implements Exception {
  BibleImportException(this.message);

  final String message;

  @override
  String toString() => 'BibleImportException: $message';
}

class MissingManifestException extends BibleImportException {
  MissingManifestException()
      : super('manifest.json was not found in the package.');
}

class InvalidManifestException extends BibleImportException {
  InvalidManifestException(List<String> issues)
      : _issues = List.unmodifiable(issues),
        super('Invalid manifest: ${issues.join('; ')}');

  final List<String> _issues;

  List<String> get issues => _issues;
}

class MissingPackageFileException extends BibleImportException {
  MissingPackageFileException(this.fileName)
      : super('Package file `$fileName` was not found.');

  final String fileName;
}

class ChecksumMismatchException extends BibleImportException {
  ChecksumMismatchException({required this.expected, required this.actual})
      : super(
            'Package checksum mismatch. Expected $expected but computed $actual.');

  final String expected;
  final String actual;
}

class UnsupportedBiblePackageFormatException extends BibleImportException {
  UnsupportedBiblePackageFormatException(String format)
      : super('Unsupported package file format `$format`.');
}

class DuplicateTranslationException extends BibleImportException {
  DuplicateTranslationException({
    required this.existing,
    required this.manifest,
  }) : super(
            'Translation `${manifest.id}` already exists and requires guidance for conflict resolution.');

  final BibleTranslation existing;
  final BiblePackageManifest manifest;
}
