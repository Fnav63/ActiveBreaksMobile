import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';
import '../services/notification_service.dart';
import '../services/work_manager_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final StorageService _storageService;
  final NotificationService _notificationService;
  final WorkManagerService _workManagerService;

  ProfileViewModel({
    required StorageService storageService,
    required NotificationService notificationService,
    required WorkManagerService workManagerService,
  })  : _storageService = storageService,
        _notificationService = notificationService,
        _workManagerService = workManagerService;

  String _userName = '';
  String _userRole = '';
  bool _notifEnabled = false;
  int _notifIntervalMinutes = 60;
  int _totalBreaksCount = 0;
  List<String> _completedBreaks = [];
  bool _isLoading = true;

  String get userName => _userName;
  String get userRole => _userRole;
  bool get notifEnabled => _notifEnabled;
  int get notifIntervalMinutes => _notifIntervalMinutes;
  int get totalBreaksCount => _totalBreaksCount;
  List<String> get completedBreaks => List.unmodifiable(_completedBreaks);
  bool get isLoading => _isLoading;
  bool get hasProfile => _userName.isNotEmpty;

  static const List<String> roleOptions = [
    'Estudiante',
    'Trabajador',
    'Estudiante / Trabajador',
    'Docente',
    'Otro',
  ];

  static const List<int> intervalOptions = [15, 30, 45, 60, 90, 120];

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    _userName = await _storageService.getUserName();
    _userRole = await _storageService.getUserRole();
    _notifEnabled = await _storageService.getNotifEnabled();
    _notifIntervalMinutes = await _storageService.getNotifIntervalMinutes();
    
    if (!intervalOptions.contains(_notifIntervalMinutes)) {
      _notifIntervalMinutes = 60;
    }
    
    _totalBreaksCount = await _storageService.getTotalBreaksCount();
    _completedBreaks = await _storageService.getCompletedBreaks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshHistory() async {
    _totalBreaksCount = await _storageService.getTotalBreaksCount();
    _completedBreaks = await _storageService.getCompletedBreaks();
    notifyListeners();
  }

  Future<void> saveUserName(String name) async {
    _userName = name.trim();
    await _storageService.saveUserName(_userName);
    notifyListeners();
  }

  Future<void> saveUserRole(String role) async {
    _userRole = role;
    await _storageService.saveUserRole(role);
    notifyListeners();
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) return;
      await _workManagerService.schedulePeriodicReminder(_notifIntervalMinutes);
    } else {
      await _workManagerService.cancelReminder();
    }

    _notifEnabled = enabled;
    await _storageService.saveNotifEnabled(enabled);
    notifyListeners();
  }

  Future<void> setNotifInterval(int minutes) async {
    _notifIntervalMinutes = minutes;
    await _storageService.saveNotifIntervalMinutes(minutes);

    if (_notifEnabled) {
      await _workManagerService.schedulePeriodicReminder(minutes);
    }
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _storageService.clearHistory();
    _completedBreaks = [];
    _totalBreaksCount = 0;
    notifyListeners();
  }
}