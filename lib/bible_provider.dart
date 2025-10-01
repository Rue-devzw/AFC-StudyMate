import 'package:flutter/material.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';

class BibleProvider with ChangeNotifier {
  List<Bible> _bibles = [];
  String _selectedBibleId = 'de4e12af7f28f599-01'; // Default to KJV

  List<Bible> get bibles => _bibles;
  String get selectedBibleId => _selectedBibleId;

  BibleProvider() {
    loadBibles();
  }

  Future<void> loadBibles() async {
    try {
      _bibles = await BibleService.getBibles();
      notifyListeners();
    } catch (e) {
      // Handle error
    }
  }

  void setBibleId(String bibleId) {
    _selectedBibleId = bibleId;
    notifyListeners();
  }
}
