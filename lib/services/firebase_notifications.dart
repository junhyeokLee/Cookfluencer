import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 🔔 로컬 알림 플러그인 초기화
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// 알림이 꺼졌을 때 푸시를 무시하는 로직을 추가

/// 🔥 Firebase 메시지 설정 초기화
Future<void> setupFirebaseMessaging(WidgetRef ref) async {
  await requestPermission();
  await setupNotification();
  await registerFCMToken();
  setupFCMListener(ref);
  setupFCMForiOS();
}

/// 📌 iOS 푸시 알림 권한 요청
Future<void> requestPermission() async {
  final messaging = FirebaseMessaging.instance;

  // 푸시 알림 권한 요청
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  // 권한이 승인되면 APNs 토큰 가져오기
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('푸시 알림 권한이 승인되었습니다.');
    String? fcmToken = await messaging.getToken();
    if (fcmToken != null) {
      print('FCM Token: $fcmToken');
      // await registerFCMToken(fcmToken); // 토큰을 Firebase에 등록하는 함수 호출
    } else {
      print('FCM Token을 가져올 수 없습니다.');
    }
  } else {
    print('푸시 알림 권한이 승인되지 않았습니다.');
  }

  print('🔔 푸시 권한 상태: ${settings.authorizationStatus}');
}

/// 📩 포그라운드/백그라운드 메시지 리스너 설정
void setupFCMListener(WidgetRef ref) {
  final FirebaseMessaging messaging = FirebaseMessaging.instance;

  // ✅ 포그라운드 상태에서 알림 수신
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    final fcm = FirebaseMessaging.instance;
    final token = await fcm.getToken();
    if (token == null) {
      print("🚫 FCM 토큰 없음");
      return;
    }

    final tokenDoc = await FirebaseFirestore.instance
        .collection("notification_tokens")
        .doc(token)
        .get();

    final data = tokenDoc.data();
    final isEnabled = data != null && data['isEnabled'] == true;

    if (isEnabled && message.notification != null) {
      print('🔥 포그라운드 메시지 수신: ${message.notification?.title}');
      showNotification(message);
    } else {
      print('🚫 Firestore 기준 isEnabled = false 이므로 포그라운드 알림 무시');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🖱️ 사용자가 알림을 클릭하여 앱을 열었습니다.');
    handleFCMNotification(message);
  });

  // ✅ 앱이 종료된 상태에서 푸시 클릭 시 실행
  messaging.getInitialMessage().then((RemoteMessage? message) {
    if (message != null) {
      print('🚀 앱이 종료된 상태에서 푸시 메시지 클릭: ${message.notification?.title}');
      handleFCMNotification(message);
    }
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}

void handleFCMNotification(RemoteMessage message) {
  if (message.data.containsKey('video_id')) {
    String videoId = message.data['video_id'];
    navigateToVideoDetailScreen(videoId);
  } else {
    navigateToHomeScreen();
  }
}
void navigateToVideoDetailScreen(String videoId) {
  print("📌 알림 클릭 → VideoDetailScreen 이동 (videoId: $videoId)");
  // GoRouter 또는 Navigator를 사용해 이동
  // navigatorKey.currentState?.pushNamed('/videoDetail/$videoId');
}

void navigateToHomeScreen() {
  print("📌 알림 클릭 → 기본 화면(HomeScreen) 이동");
  // navigatorKey.currentState?.pushNamed('/');
}


/// 📌 백그라운드에서 메시지 수신 시 실행되는 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  final token = await FirebaseMessaging.instance.getToken();
  if (token == null) return;

  final tokenDoc = await FirebaseFirestore.instance
      .collection("notification_tokens")
      .doc(token)
      .get();

  final data = tokenDoc.data();
  final isEnabled = data != null && data['isEnabled'] == true;

  if (isEnabled && message.notification != null) {
    print("✅ 백그라운드 알림 수신: ${message.notification?.title}");
    showNotification(message);
  } else {
    print("🚫 isEnabled == false 이므로 알림 표시 안함 (백그라운드)");
  }
}

// 알림 설정 상태를 확인하는 함수
Future<bool> checkNotificationStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notification_enabled') ?? false;
}

Future<void> showNotification(RemoteMessage message) async {
  print('🔔 알림 표시: ${message.notification?.title}');
  String? videoId = message.data.containsKey('video_id') ? message.data['video_id'] : null;
  if (Platform.isIOS) {

  }
  else {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'high_importance_channel', // 채널 ID (Android에서 필수)
      '알림 채널', // 채널 이름
      channelDescription: '중요한 알림을 위한 채널',
      importance: Importance.max,
      priority: Priority.high,
    );


    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails, iOS: iosDetails);

    await flutterLocalNotificationsPlugin.show(
      DateTime
          .now()
          .millisecondsSinceEpoch
          .remainder(100000), // 중복 방지 ID
      message.notification?.title ?? '새 알림',
      message.notification?.body ?? '알림 내용',
      notificationDetails,
    );
  }
}
/// 🔔 로컬 알림 설정
Future<void> setupNotification() async {
  await Firebase.initializeApp();

  // Android 초기화 설정
  const AndroidInitializationSettings androidInitializationSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS 초기화 설정 (IOSInitializationSettings 사용)
  const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings();

  // 초기화 설정 결합
  const InitializationSettings initializationSettings = InitializationSettings(
    android: androidInitializationSettings,
    iOS: initializationSettingsIOS,  // iOS 초기화 설정
  );

  // 로컬 알림 플러그인 초기화
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // 백그라운드에서 메시지 처리
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}


/// ✅ FCM 토큰을 가져와 Firestore에 저장
Future<void> registerFCMToken() async {
  final fcm = FirebaseMessaging.instance;
  final token = await fcm.getToken();
  if (token == null) return;

  final prefs = await SharedPreferences.getInstance();
  bool isNotificationEnabled = prefs.getBool('notification_enabled') ?? false;

  final docRef = FirebaseFirestore.instance.collection('notification_tokens').doc(token);
  final docSnap = await docRef.get();

  if (docSnap.exists) {
    // 🔄 기존 문서가 있으면 업데이트만
    await docRef.update({
      'isEnabled': isNotificationEnabled,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  } else {
    // 🆕 처음 등록하는 경우
    await docRef.set({
      'token': token,
      'isEnabled': isNotificationEnabled,
      'userId': null, // 🔹 로그인 상태에 따라 나중에 연결됨
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  print("✅ FCM 토큰 Firestore 등록 완료: $token");

  // 🔁 토큰이 변경될 때도 자동 업데이트
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    final newDocRef = FirebaseFirestore.instance.collection('notification_tokens').doc(newToken);
    final newDocSnap = await newDocRef.get();

    if (newDocSnap.exists) {
      await newDocRef.update({
        'isEnabled': isNotificationEnabled,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      await newDocRef.set({
        'token': newToken,
        'isEnabled': isNotificationEnabled,
        'userId': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }

    print("🔄 새로 발급된 FCM 토큰으로 업데이트 완료: $newToken");
  });
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



// Helper function to check if notifications are enabled
Future<bool> checkNotificationEnabled() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notification_enabled') ?? false;
}