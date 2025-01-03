import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, String>> getAppInfo() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  return {
    'appName': packageInfo.appName,
    'packageName': packageInfo.packageName,
    'version': packageInfo.version,
    'buildNumber': packageInfo.buildNumber,
  };
}

// 알림 설정 저장
// Future<void> saveNotificationSetting(bool isEnabled) async {
//   final prefs = await SharedPreferencesWithCache.getInstance();
//   await prefs.setBool('notification_enabled', isEnabled);
// }
