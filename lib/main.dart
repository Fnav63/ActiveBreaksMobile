import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'viewmodels/breaks_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/timer_viewmodel.dart';

import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/breaks_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/break_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final storageService = StorageService();

  runApp(ActiveBreaksApp(
    notificationService: notificationService,
    storageService: storageService,
  ));
}

class ActiveBreaksApp extends StatelessWidget {
  final NotificationService notificationService;
  final StorageService storageService;

  const ActiveBreaksApp({
    super.key,
    required this.notificationService,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BreaksViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(
            storageService: storageService,
            notificationService: notificationService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerViewModel(
            notificationService: notificationService,
            storageService: storageService,
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ActiveBreaks',
        theme: _buildTheme(),
        initialRoute: '/splash',
        routes: {
          '/splash': (_) => const SplashScreen(),
          '/home': (_) => const HomeScreen(),
          '/breaks': (_) => const BreaksListScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/about': (_) => const AboutScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/history': (_) => const HistoryScreen(),
        },
        onGenerateRoute: (settings) {
        if (settings.name == '/break-detail') {
          return MaterialPageRoute(
            builder: (_) => const BreakDetailScreen(),
          );
        }
        return null;
      },
      ),
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
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
    );
  }
}