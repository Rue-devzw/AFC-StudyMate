import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/lesson.dart';
import 'cache_service.dart';

class DataService {
  static Future<List<LessonGroup>> getLessonGroups() async {
    final cachedLessonGroups = await CacheService.getLessonGroups();
    if (cachedLessonGroups != null) {
      return cachedLessonGroups;
    }

    final String response = await rootBundle.loadString('assets/lessons.json');
    final data = await json.decode(response) as List;
    final lessonGroups = data.map((lg) => LessonGroup.fromJson(lg)).toList();
    await CacheService.saveLessonGroups(lessonGroups);
    return lessonGroups;
  }
}
