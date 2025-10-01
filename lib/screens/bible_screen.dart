import 'package:flutter/material.dart';
import '../models/bible.dart';
import '../services/bible_service.dart';
import 'book_screen.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  _BibleScreenState createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  final Bible bible = BibleService.getBible();
  List<Book> filteredBooks = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredBooks = bible.books;
    searchController.addListener(() {
      filterBooks();
    });
  }

  void filterBooks() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredBooks = bible.books
          .where((book) => book.name.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.white70),
          ),
          style: TextStyle(color: Colors.white, fontSize: 18.0),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              searchController.clear();
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredBooks.length,
        itemBuilder: (context, index) {
          final book = filteredBooks[index];
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
