enum ImportStage {
  preparing,
  extracting,
  readingManifest,
  validatingManifest,
  verifyingChecksum,
  parsingContent,
  writingMetadata,
  writingVerses,
  buildingSearchIndex,
  completed,
}

enum ImportConflictResolution {
  prompt,
  replace,
  skip,
}

class ImportProgress {
  ImportProgress({
    required this.stage,
    this.progress,
    this.message,
  });

  final ImportStage stage;
  final double? progress;
  final String? message;
}
