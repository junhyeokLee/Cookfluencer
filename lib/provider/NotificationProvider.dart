import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ✅ 알림 설정 상태 관리 Provider
final notificationProvider = StateNotifierProvider<NotificationNotifier, bool>((ref) {
  return NotificationNotifier();
});

class NotificationNotifier extends StateNotifier<bool> {
  NotificationNotifier() : super(true) {  // ✅ 기본값을 true로 설정
    _loadNotificationSetting();
  }

  /// ✅ SharedPreferences에서 알림 설정 불러오기
  Future<void> _loadNotificationSetting() async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getBool('notification_enabled') ?? false;  // ✅ 기본값 true
  }

  /// ✅ 알림 설정 변경 시 저장
  Future<void> toggleNotification(bool isEnabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', isEnabled);
    state = isEnabled;
  }
}