class LessonGroup {
  final String title;
  final List<Lesson> lessons;

  LessonGroup({required this.title, required this.lessons});

  factory LessonGroup.fromJson(Map<String, dynamic> json) {
    return LessonGroup(
      title: json['title'],
      lessons: (json['lessons'] as List).map((l) => Lesson.fromJson(l)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'lessons': lessons.map((l) => l.toJson()).toList(),
      };
}

class Lesson {
  final String title;
  final String introduction;
  final List<Section> sections;

  Lesson({
    required this.title,
    required this.introduction,
    required this.sections,
  });

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      title: json['title'],
      introduction: json['introduction'],
      sections: (json['sections'] as List).map((s) => Section.fromJson(s)).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'introduction': introduction,
        'sections': sections.map((s) => s.toJson()).toList(),
      };
}

class Section {
  final String title;
  final String content;
  final String? url;

  Section({required this.title, required this.content, this.url});

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      title: json['title'],
      content: json['content'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'url': url,
      };
}
