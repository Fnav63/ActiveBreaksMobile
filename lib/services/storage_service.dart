import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const _keyUserName = 'user_name';
  static const _keyUserRole = 'user_role';
  static const _keyNotifEnabled = 'notif_enabled';
  static const _keyNotifIntervalMinutes = 'notif_interval_minutes';
  static const _keyCompletedBreaks = 'completed_breaks';
  static const _keyTotalBreaksCount = 'total_breaks_count';

  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName) ?? '';
  }

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserName, name);
  }

  Future<String> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole) ?? '';
  }

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserRole, role);
  }

  Future<bool> getNotifEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyNotifEnabled) ?? false;
  }

  Future<void> saveNotifEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyNotifEnabled, enabled);
  }

  Future<int> getNotifIntervalMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyNotifIntervalMinutes) ?? 60;
  }

  Future<void> saveNotifIntervalMinutes(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyNotifIntervalMinutes, minutes);
  }

  Future<List<String>> getCompletedBreaks() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_keyCompletedBreaks) ?? [];
  }

  Future<void> addCompletedBreak(String breakTitle) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_keyCompletedBreaks) ?? [];
    final entry = '$breakTitle|${DateTime.now().toIso8601String()}';
    current.insert(0, entry);
    if (current.length > 50) current.removeLast();
    await prefs.setStringList(_keyCompletedBreaks, current);

    final count = prefs.getInt(_keyTotalBreaksCount) ?? 0;
    await prefs.setInt(_keyTotalBreaksCount, count + 1);
  }

  Future<int> getTotalBreaksCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyTotalBreaksCount) ?? 0;
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyCompletedBreaks);
    await prefs.remove(_keyTotalBreaksCount);
  }
}