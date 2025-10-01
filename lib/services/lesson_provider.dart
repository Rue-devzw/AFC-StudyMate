import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson.dart';

class LessonProvider {
  Future<List<LessonGroup>> loadLessons() async {
    final String jsonString = await rootBundle.loadString('assets/lessons.json');
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => LessonGroup.fromJson(json)).toList();
  }
}
