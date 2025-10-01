class Lesson {
  final String title;
  final String date;
  final String introduction;
  final List<Section> sections;

  Lesson({
    required this.title,
    required this.date,
    required this.introduction,
    required this.sections,
  });
}

class Section {
  final String title;
  final String content;

  Section({required this.title, required this.content});
}
