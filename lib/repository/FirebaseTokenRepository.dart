import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

class FirebaseTokenRepository {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ✅ **FCM 토큰 등록 (기기 단위로 저장 & 로그인하면 UID 연결)**
  Future<void> registerFCMToken() async {
    final token = await _fcm.getToken();
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    bool isNotificationEnabled = prefs.getBool('notification_enabled') ?? true; // 기본값: ON

    final docRef = _firestore.collection('notification_tokens').doc(token);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      // 🔹 기존 데이터 업데이트 (userId 변경 및 isEnabled 유지)
      await docRef.update({
        'isEnabled': isNotificationEnabled,
      });
    }
  }

  /// ✅ **로그아웃 시 userId만 제거 (토큰은 유지)**
  Future<void> removeFCMToken() async {
    final token = await _fcm.getToken();
    if (token == null) return;

    final docRef = _firestore.collection('notification_tokens').doc(token);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      await docRef.update({'userId': null}); // 🔹 userId만 제거, 토큰 유지
      print("✅ Firestore에서 userId 제거 완료 (로그아웃)");
    }
  }

  /// ✅ **푸시 알림 ON/OFF 설정 저장**
  Future<void> toggleNotification(bool isEnabled) async {
    final token = await _fcm.getToken();
    if (token == null) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notification_enabled', isEnabled); // 로컬 저장

    final docRef = _firestore.collection('notification_tokens').doc(token);
    final docSnap = await docRef.get();

    if (docSnap.exists) {
      await docRef.update({'isEnabled': isEnabled});
      print("✅ Firestore 푸시 알림 상태 변경: ${isEnabled ? 'ON' : 'OFF'}");
    }
  }
}