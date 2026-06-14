import 'package:workmanager/workmanager.dart';
import 'notification_service.dart';

const String remindBreakTask = 'remindBreakTask';

class WorkManagerService {
  static final WorkManagerService _instance = WorkManagerService._internal();
  factory WorkManagerService() => _instance;
  WorkManagerService._internal();

  Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  Future<void> schedulePeriodicReminder(int intervalMinutes) async {
    await Workmanager().cancelByTag(remindBreakTask);

    final NotificationService notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.showBreakReminderNotification();

    await Workmanager().registerPeriodicTask(
      remindBreakTask,
      remindBreakTask,
      frequency: Duration(minutes: intervalMinutes),
      backoffPolicy: BackoffPolicy.exponential,
    );
  }

  Future<void> cancelReminder() async {
    await Workmanager().cancelByTag(remindBreakTask);
  }
  Future<void> cancelAllTasks() async {
    await Workmanager().cancelAll();

    final NotificationService notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.cancelAll();
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final NotificationService notificationService = NotificationService();
    await notificationService.initialize();
    await notificationService.showBreakReminderNotification();
    return true;
  });
}