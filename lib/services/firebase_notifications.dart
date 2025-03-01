import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/NotificationProvider.dart';

// 🔔 로컬 알림 플러그인 초기화
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// 알림이 꺼졌을 때 푸시를 무시하는 로직을 추가

/// 🔥 Firebase 메시지 설정 초기화
Future<void> setupFirebaseMessaging(WidgetRef ref) async {
  await Firebase.initializeApp();
  requestPermission();
  registerFCMToken();
  setupNotification();
  setupFCMListener(ref);
  setupFCMForiOS();
}

/// 📌 iOS 푸시 알림 권한 요청
void requestPermission() async {
  final messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  print('🔔 iOS 푸시 권한 상태: ${settings.authorizationStatus}');
  if (settings.authorizationStatus == AuthorizationStatus.denied) {
    print("🚨 푸시 알림이 차단됨! 사용자가 설정에서 활성화해야 함");
  }
}

/// ✅ FCM 토큰을 가져와 Firestore에 저장
Future<void> registerFCMToken() async {
  final fcm = FirebaseMessaging.instance;
  final token = await fcm.getToken();

  if (token == null) return;

  print('📌 FCM Token: $token');

  final userDeviceId = 'device_${DateTime.now().millisecondsSinceEpoch}';
  await FirebaseFirestore.instance.collection('notification_tokens').doc(userDeviceId).set({
    'token': token,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

/// 📩 포그라운드/백그라운드 메시지 리스너 설정
void setupFCMListener(WidgetRef ref) {
  final isNotificationEnabled = ref.watch(notificationProvider);  // 알림 상태 가져오기

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('🔥 포그라운드 메시지 수신: ${message.notification?.title}');
    if (isNotificationEnabled && message.notification != null) {
      showNotification(message);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🖱️ 사용자가 알림을 클릭하여 앱을 열었습니다.');
  });

  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('🚀 앱이 종료된 상태에서 푸시 메시지 수신: ${message.notification?.title}');
      if (isNotificationEnabled) {
        showNotification(message);
      }
    }
  });
}

/// 📌 백그라운드에서 메시지 수신 시 실행되는 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🌙 백그라운드에서 푸시 수신: ${message.notification?.title}");

  final isNotificationEnabled = await checkNotificationEnabled();  // 알림 설정 상태 확인
  if (isNotificationEnabled) {
    showNotification(message);  // 알림이 활성화되어 있으면 알림 표시
  }
}

/// ✅ APNs 연동 (iOS용)
void setupFCMForiOS() async {
  if (Platform.isIOS) {
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    print("APNs 토큰: $apnsToken");

    if (apnsToken != null) {
      await FirebaseMessaging.instance.subscribeToTopic('all_ios_users');
      print("iOS FCM 등록 완료");
    }
  }
}

/// 🔔 로컬 알림 설정
void setupNotification() async {
  await Firebase.initializeApp();

  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings =
  InitializationSettings(android: androidInitializationSettings);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

/// 🔥 푸시 알림 표시
Future<void> showNotification(RemoteMessage message) async {
  print('🔔 알림 표시: ${message.notification?.title}');

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'high_importance_channel',
    '알림 채널',
    channelDescription: '중요한 알림을 위한 채널',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch.remainder(100000),
    message.notification?.title ?? '새 알림',
    message.notification?.body ?? '알림 내용',
    notificationDetails,
  );
}

// Helper function to check if notifications are enabled
Future<bool> checkNotificationEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notification_enabled') ?? false;
}