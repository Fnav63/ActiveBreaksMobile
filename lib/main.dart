import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/notification_service.dart';
import 'services/storage_service.dart';
import 'viewmodels/breaks_viewmodel.dart';
import 'viewmodels/profile_viewmodel.dart';
import 'viewmodels/timer_viewmodel.dart';

import 'screens/splash_screen.dart';
import 'screens/main_shell.dart';
import 'screens/breaks_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/about_screen.dart';
import 'screens/break_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/history_screen.dart';
import 'viewmodels/beta_testing_viewmodel.dart';
import 'screens/beta_testing_screen.dart';
import 'services/work_manager_service.dart';
import 'viewmodels/preferences_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final notificationService = NotificationService();
  await notificationService.initialize();

  final workManagerService = WorkManagerService();
  await workManagerService.initialize();

  final storageService = StorageService();

  runApp(ActiveBreaksApp(
    notificationService: notificationService,
    storageService: storageService,
    workManagerService: workManagerService,
  ));
}

class ActiveBreaksApp extends StatelessWidget {
  final NotificationService notificationService;
  final StorageService storageService;
  final WorkManagerService workManagerService;

  const ActiveBreaksApp({
    super.key,
    required this.notificationService,
    required this.storageService,
    required this.workManagerService,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => BreaksViewModel(
            storageService: storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProfileViewModel(
            storageService: storageService,
            notificationService: notificationService,
            workManagerService: workManagerService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerViewModel(
            notificationService: notificationService,
            storageService: storageService,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => BetaTestingViewModel(),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesViewModel(
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
          '/home': (_) => const MainShell(),
          '/breaks': (_) => const BreaksListScreen(),
          '/profile': (_) => const ProfileScreen(),
          '/about': (_) => const AboutScreen(),
          '/settings': (_) => const SettingsScreen(),
          '/history': (_) => const HistoryScreen(),
          '/beta-testing': (_) => const BetaTestingScreen(),
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