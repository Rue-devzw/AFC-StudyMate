import 'package:bible_study_app/bible_provider.dart';
import 'package:bible_study_app/services/bible_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../screens/bible_screen.dart';
import '../screens/lessons_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const BibleScreen(),
    const LessonsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final bibleProvider = Provider.of<BibleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AFC StudyMate'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.themeMode == ThemeMode.dark
                ? Icons.light_mode
                : Icons.dark_mode),
            onPressed: () => themeProvider.toggleTheme(),
            tooltip: 'Toggle Theme',
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF3F51B5),
              ),
              child: Text(
                'Bible Translations',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('King James Version'),
              onTap: () {
                bibleProvider.setBible(BibleService.getBible());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Amplified Version'),
              onTap: () {
                bibleProvider.setBible(BibleService.getAmplifiedBible());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Ndebele Version'),
              onTap: () {
                bibleProvider.setBible(BibleService.getNdebeleBible());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Shona Version'),
              onTap: () {
                // Handle Shona selection
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.book_online),
              title: const Text('Portuguese Version'),
              onTap: () {
                // Handle Portuguese selection
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Bible',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Lessons',
          ),
        ],
      ),
    );
  }
}
