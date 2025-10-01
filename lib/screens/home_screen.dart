import 'package:flutter/material.dart';
import '../screens/bible_screen.dart';
import '../screens/lessons_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AFC StudyMate')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BibleScreen()),
                );
              },
              child: const Text('Bible'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LessonsScreen(),
                  ),
                );
              },
              child: const Text('Lessons'),
            ),
          ],
        ),
      ),
    );
  }
}
