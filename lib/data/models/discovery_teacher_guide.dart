class DiscoveryTeacherGuide {
  const DiscoveryTeacherGuide({
    required this.lessonId,
    required this.pdfPath,
    required this.startPage,
  });

  final String lessonId;
  final String pdfPath;
  final int startPage;

  @override
  String toString() =>
      'DiscoveryTeacherGuide(lessonId: $lessonId, pdfPath: $pdfPath, startPage: $startPage)';
}
