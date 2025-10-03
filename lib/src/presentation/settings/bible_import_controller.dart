import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/entities.dart';
import '../../domain/bible/import/exceptions.dart';
import '../../domain/bible/import/import_bible_package_usecase.dart';
import '../../domain/bible/import/import_models.dart';

class BibleImportState {
  const BibleImportState({
    this.isImporting = false,
    this.progress,
    this.imported,
    this.error,
    this.conflict,
    this.packageFile,
  });

  final bool isImporting;
  final ImportProgress? progress;
  final BibleTranslation? imported;
  final String? error;
  final DuplicateTranslationException? conflict;
  final File? packageFile;

  bool get hasOutcome => imported != null || error != null;
}

class BibleImportController extends StateNotifier<BibleImportState> {
  BibleImportController(this._useCase) : super(const BibleImportState());

  final ImportBiblePackageUseCase _useCase;

  Future<void> importPackage(
    File file, {
    ImportConflictResolution conflictResolution = ImportConflictResolution.prompt,
  }) async {
    state = BibleImportState(
      isImporting: true,
      progress: ImportProgress(stage: ImportStage.preparing, message: 'Preparing import...'),
      packageFile: file,
    );
    try {
      final translation = await _useCase(
        packageFile: file,
        conflictResolution: conflictResolution,
        onProgress: (progress) {
          state = BibleImportState(
            isImporting: true,
            progress: progress,
            packageFile: file,
          );
        },
      );
      state = BibleImportState(imported: translation);
    } on DuplicateTranslationException catch (conflict) {
      state = BibleImportState(conflict: conflict, packageFile: file);
    } on BibleImportException catch (error) {
      state = BibleImportState(error: error.message, packageFile: file);
    } catch (error) {
      state = BibleImportState(error: error.toString(), packageFile: file);
    }
  }

  Future<void> resolveConflict(ImportConflictResolution resolution) async {
    final file = state.packageFile;
    if (file == null) {
      return;
    }
    await importPackage(file, conflictResolution: resolution);
  }

  void clearOutcome() {
    state = const BibleImportState();
  }
}
