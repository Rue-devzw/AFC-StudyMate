import 'package:bible_study_app/bible_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import '../models/bible.dart';
import 'book_screen.dart';

class BibleScreen extends StatefulWidget {
  const BibleScreen({super.key});

  @override
  _BibleScreenState createState() => _BibleScreenState();
}

class _BibleScreenState extends State<BibleScreen> {
  List<Book> filteredBooks = [];
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bible = Provider.of<BibleProvider>(context, listen: false).bible;
    filteredBooks = bible.books;
    searchController.addListener(() {
      filterBooks();
    });
  }

  void filterBooks() {
    final bible = Provider.of<BibleProvider>(context, listen: false).bible;
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
    final bible = Provider.of<BibleProvider>(context).bible;
    if (searchController.text.isEmpty) {
      filteredBooks = bible.books;
    }

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search Books...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: AnimationLimiter(
              child: GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemCount: filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = filteredBooks[index];
                  return AnimationConfiguration.staggeredGrid(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    columnCount: 2,
                    child: ScaleAnimation(
                      child: FadeInAnimation(
                        child: Card(
                          elevation: 2.0,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BookScreen(book: book),
                                ),
                              );
                            },
                            child: Center(
                              child: Text(
                                book.name,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
