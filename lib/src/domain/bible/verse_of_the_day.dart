class VerseOfTheDay {
  final String text;
  final String reference;

  const VerseOfTheDay({required this.text, required this.reference});

  factory VerseOfTheDay.fromJson(Map<String, dynamic> json) {
    return VerseOfTheDay(
      text: json['text'] as String,
      reference: json['reference'] as String,
    );
  }
}
