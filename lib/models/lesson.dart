class Lesson {
  final String title;
  final String date;
  final String introduction;
  final List<Section> sections;
  final String ageGroup;

  Lesson({
    required this.title,
    required this.date,
    required this.introduction,
    required this.sections,
    required this.ageGroup,
  });
}

class Section {
  final String title;
  final String content;

  Section({required this.title, required this.content});
}
