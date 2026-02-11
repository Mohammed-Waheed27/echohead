import '../../di/service_locator.dart';

class FirstLaunchHandler {
  static const String _firstLaunchKey = 'is_first_launch';

  /// Check if this is the first launch of the app
  static Future<bool> isFirstLaunch() async {
    final prefs = ServiceLocator.sharedPreferences;
    return prefs.getBool(_firstLaunchKey) ?? true;
  }

  /// Mark that the app has been launched before
  static Future<void> setFirstLaunchComplete() async {
    final prefs = ServiceLocator.sharedPreferences;
    await prefs.setBool(_firstLaunchKey, false);
  }
}
