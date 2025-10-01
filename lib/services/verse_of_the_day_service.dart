import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verse_of_the_day.dart';

class VerseOfTheDayService {
  final String _url = 'https://beta.ourmanna.com/api/v1/get?format=json&order=daily';

  Future<VerseOfTheDay> getVerseOfTheDay() async {
    final response = await http.get(Uri.parse(_url));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return VerseOfTheDay.fromJson(json['verse']['details']);
    } else {
      throw Exception('Failed to load verse of the day');
    }
  }
}
