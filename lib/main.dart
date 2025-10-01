
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const AFCStudyMateApp(),
    ),
  );
}

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}

class AFCStudyMateApp extends StatelessWidget {
  const AFCStudyMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3F51B5);
    const Color backgroundColor = Color(0xFFE8EAF6);
    const Color accentColor = Color(0xFFFFAB40);

    final TextTheme appTextTheme = TextTheme(
      displayLarge: GoogleFonts.playfair(fontSize: 57, fontWeight: FontWeight.bold),
      titleLarge: GoogleFonts.playfair(fontSize: 22, fontWeight: FontWeight.w500),
      bodyMedium: GoogleFonts.ptSans(fontSize: 14),
    );

    final ThemeData theme = ThemeData(
      useMaterial3: true,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
        secondary: accentColor,
      ),
      textTheme: appTextTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        titleTextStyle: GoogleFonts.playfair(fontSize: 24, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          textStyle: GoogleFonts.ptSans(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );

    return MaterialApp(
      title: 'AFC StudyMate',
      theme: theme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AFC StudyMate'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to AFC StudyMate!', style: Theme.of(context).textTheme.displayLarge),
            const SizedBox(height: 20),
            Text('Your companion for spiritual growth.', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
