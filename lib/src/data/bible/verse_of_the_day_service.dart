import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../domain/bible/verse_of_the_day.dart';

class VerseOfTheDayService {
  const VerseOfTheDayService();

  static const _url =
      'https://beta.ourmanna.com/api/v1/get?format=json&order=daily';

  Future<VerseOfTheDay> fetch() async {
    final response = await http.get(Uri.parse(_url));
    if (response.statusCode != 200) {
      throw Exception('Failed to load verse of the day');
    }
    final jsonBody = json.decode(response.body) as Map<String, dynamic>;
    return VerseOfTheDay.fromJson(
      Map<String, dynamic>.from(jsonBody['verse']['details'] as Map),
    );
  }
}
