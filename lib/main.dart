import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const ActiveBreaksApp());
}

class ActiveBreaksApp extends StatelessWidget {
  const ActiveBreaksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ActiveBreaks',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 44, 83, 46),
          secondary: Colors.green,
          surface: Color.fromARGB(255, 44, 83, 46),
          onSurface: Colors.white,
          onPrimary: Colors.white,
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 18, 35),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 44, 83, 46),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}