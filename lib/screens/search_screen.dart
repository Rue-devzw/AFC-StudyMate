import 'package:bible_study_app/models/bible.dart';
import 'package:bible_study_app/services/bible_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../bible_provider.dart';

class SearchScreen extends StatelessWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final bibleProvider = Provider.of<BibleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$query"'),
      ),
      body: FutureBuilder<List<Verse>>(
        future: BibleService.searchBible(bibleProvider.selectedBibleId, query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No results found.'));
          } else {
            final verses = snapshot.data!;
            return ListView.builder(
              itemCount: verses.length,
              itemBuilder: (context, index) {
                final verse = verses[index];
                return ListTile(
                  title: Text(verse.text),
                  subtitle: Text(verse.id),
                );
              },
            );
          }
        },
      ),
    );
  }
}
