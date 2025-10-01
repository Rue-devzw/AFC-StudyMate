import 'package:flutter/material.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';
import 'book_screen.dart';

class BibleScreen extends StatelessWidget {
  const BibleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Bible bible = BibleService.getBible();

    return Scaffold(
      body: ListView.builder(
        itemCount: bible.books.length,
        itemBuilder: (context, index) {
          final book = bible.books[index];
          return ListTile(
            title: Text(book.name),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BookScreen(book: book)),
              );
            },
          );
        },
      ),
    );
  }
}
