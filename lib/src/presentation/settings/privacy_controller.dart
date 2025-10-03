import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/bible/reading_progress/entities.dart';
import '../../domain/bible/reading_progress/repositories.dart';
import '../../domain/settings/repositories.dart';
import '../../infrastructure/privacy/privacy_service.dart';

class PrivacyState {
  const PrivacyState({
    this.isExporting = false,
    this.isDeleting = false,
    this.lastExportPath,
    this.lastError,
  });

  final bool isExporting;
  final bool isDeleting;
  final String? lastExportPath;
  final String? lastError;

  PrivacyState copyWith({
    bool? isExporting,
    bool? isDeleting,
    String? lastExportPath,
    bool clearExportPath = false,
    String? lastError,
    bool clearError = false,
  }) {
    return PrivacyState(
      isExporting: isExporting ?? this.isExporting,
      isDeleting: isDeleting ?? this.isDeleting,
      lastExportPath:
          clearExportPath ? null : (lastExportPath ?? this.lastExportPath),
      lastError: clearError ? null : (lastError ?? this.lastError),
    );
  }
}

class PrivacyController extends StateNotifier<PrivacyState> {
  PrivacyController(
    this._privacyService,
    this._readingProgressRepository,
    this._settingsRepository,
  ) : super(const PrivacyState());

  final PrivacyService _privacyService;
  final ReadingProgressRepository _readingProgressRepository;
  final SettingsRepository _settingsRepository;

  Future<File?> exportUserData(String userId) async {
    state = state.copyWith(isExporting: true, clearError: true);
    try {
      final theme = await _settingsRepository.getThemeMode(userId);
      final readingPosition =
          await _readingProgressRepository.getLastPosition(userId);
      final preferences = <String, dynamic>{
        'theme': theme.name,
      };
      if (readingPosition != null) {
        preferences['readingProgress'] = _toJson(readingPosition);
      }
      final result = await _privacyService.exportUserData(
        userId,
        preferences: preferences,
      );
      state = state.copyWith(
        isExporting: false,
        lastExportPath: result.file.path,
      );
      return result.file;
    } catch (error) {
      state = state.copyWith(
        isExporting: false,
        lastError: error.toString(),
      );
      return null;
    }
  }

  Future<bool> deleteUserData(String userId) async {
    state = state.copyWith(isDeleting: true, clearError: true);
    try {
      await _privacyService.deleteUserData(userId);
      state = state.copyWith(isDeleting: false, clearExportPath: true);
      return true;
    } catch (error) {
      state = state.copyWith(
        isDeleting: false,
        lastError: error.toString(),
      );
      return false;
    }
  }

  Map<String, dynamic> _toJson(ReadingPosition position) {
    return {
      'translationId': position.translationId,
      'bookId': position.bookId,
      'chapter': position.chapter,
      'verse': position.verse,
      'updatedAt': position.updatedAt.toIso8601String(),
    };
  }
}
