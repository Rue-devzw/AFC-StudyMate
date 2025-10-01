class VerseOfTheDay {
  final String text;
  final String reference;

  VerseOfTheDay({required this.text, required this.reference});

  factory VerseOfTheDay.fromJson(Map<String, dynamic> json) {
    return VerseOfTheDay(
      text: json['text'],
      reference: json['reference'],
    );
  }
}
