import 'package:meta/meta.dart';

@immutable
class TeacherGuide {
  const TeacherGuide({
    required this.lessonId,
    required this.content,
    required this.pdfPath,
  });

  factory TeacherGuide.fromJson(Map<String, dynamic> json) {
    return TeacherGuide(
      lessonId: json['lesson_id'] as String,
      content: json['content'] as String,
      pdfPath: json['pdf_path'] as String,
    );
  }

  final String lessonId;
  final String content;
  final String pdfPath;

  TeacherGuide copyWith({
    String? lessonId,
    String? content,
    String? pdfPath,
  }) {
    return TeacherGuide(
      lessonId: lessonId ?? this.lessonId,
      content: content ?? this.content,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'lesson_id': lessonId,
    'content': content,
    'pdf_path': pdfPath,
  };
}
