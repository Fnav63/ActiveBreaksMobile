import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/breaks_list_screen.dart';
import 'screens/about_screen.dart';
import 'screens/splash_screen.dart';

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
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/breaks': (context) => const BreaksListScreen(),
        '/about': (context) => const AboutScreen(),
      },

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
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),

        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}