import 'package:bible_study_app/bible_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';
import '../screens/bible_screen.dart';
import '../screens/lessons_screen.dart';
import '../screens/about_screen.dart';

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
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const UserAccountsDrawerHeader(
              accountName: Text('AFC User'),
              accountEmail: Text(''),
              currentAccountPicture: CircleAvatar(
                child: Text('A'),
              ),
            ),
            ...bibleProvider.bibles.map((bible) => ListTile(
                  leading: const Icon(Icons.book_online),
                  title: Text(bible.translation),
                  onTap: () {
                    bibleProvider.setBibleId(bible.id);
                    Navigator.pop(context);
                  },
                )),
            const Divider(),
            ListTile(
              leading: Icon(themeProvider.themeMode == ThemeMode.dark
                  ? Icons.light_mode
                  : Icons.dark_mode),
              title: const Text('Toggle Theme'),
              onTap: () {
                themeProvider.toggleTheme();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()),
                );
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
