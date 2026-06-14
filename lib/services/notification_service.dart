import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = true;
  }

  void _onNotificationTap(NotificationResponse response) {
  }

  Future<bool> requestPermissions() async {
    final AndroidFlutterLocalNotificationsPlugin? android =
    _plugin.resolvePlatformSpecificImplementation();
    
    if (android != null) {
      final granted = await android.requestNotificationsPermission();
      return granted ?? false;
    }

    final IOSFlutterLocalNotificationsPlugin? ios =
    _plugin.resolvePlatformSpecificImplementation();
    
    if (ios != null) {
      final granted = await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      return granted ?? false;
    }

    return false;
  }

  Future<void> showReminderTestNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'break_reminder',
    'Recordatorio de Pausa',
    channelDescription: 'Recordatorio para realizar pausas activas',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
    icon: '@mipmap/ic_launcher',
  );

  const details = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await _plugin.show(
    3,
    'Recordatorio activado',
    'Recibiras recordatorios de pausas activas.',
    details,
  );
}

  Future<void> showBreakCompletedNotification(String breakTitle) async {
    const androidDetails = AndroidNotificationDetails(
      'break_completed',
      'Pausa Completada',
      channelDescription: 'Notificación al completar una pausa activa',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      1,
      '¡Pausa completada!',
      '$breakTitle finalizada. ¡Excelente trabajo!',
      details,
    );
  }

  /*Future<void> schedulePeriodicReminder(int intervalMinutes) async {
    await cancelReminders();

    const androidDetails = AndroidNotificationDetails(
      'break_reminder',
      'Recordatorio de Pausa',
      channelDescription: 'Recordatorio periódico para realizar pausas activas',
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
      icon: '@mipmap/ic_launcher',
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    final repeatInterval = intervalMinutes <= 60
        ? RepeatInterval.hourly
        : RepeatInterval.daily;

    await _plugin.periodicallyShow(
      2,
      'Hora de una pausa activa',
      'Han pasado $intervalMinutes minutos. ¡Tómate un descanso!',
      repeatInterval,
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }*/
  Future<void> showBreakReminderNotification() async {
  const androidDetails = AndroidNotificationDetails(
    'break_reminder',
    'Recordatorio de Pausa',
    channelDescription:
        'Recordatorio periodico para realizar pausas activas',
    importance: Importance.defaultImportance,
    priority: Priority.defaultPriority,
  );

  const details = NotificationDetails(android: androidDetails);

  await _plugin.show(
    2,
    'Hora de una pausa activa',
    'Toma un descanso y realiza una pausa activa.',
    details,
  );
}

  /*Future<void> cancelReminders() async {
    await _plugin.cancel(2);
  }*/

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}