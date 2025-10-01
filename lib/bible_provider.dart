import 'package:flutter/material.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';

class BibleProvider with ChangeNotifier {
  Bible _bible = BibleService.getBible();

  Bible get bible => _bible;

  void setBible(Bible bible) {
    _bible = bible;
    notifyListeners();
  }
}
