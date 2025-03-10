import 'dart:io';
import 'package:adpopcornssp_flutter/adpopcornssp_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/app_theme.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/firebase_options.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:cookfluencer/util/AdPopcornInterstitialUtil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/NotificationProvider.dart';
import 'common/util/AdManager.dart';

// Firebase 초기화 및 앱 시작
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // 푸시 알림 권한 요청 및 FCM 토큰 등록
  await requestPermission();
  await setupNotification();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

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
      await registerFCMToken(fcmToken); // 토큰을 Firebase에 등록하는 함수 호출
    } else {
      print('FCM Token을 가져올 수 없습니다.');
    }
  } else {
    print('푸시 알림 권한이 승인되지 않았습니다.');
  }

  print('🔔 푸시 권한 상태: ${settings.authorizationStatus}');
}


Future<void> registerFCMToken(String token) async {
  final userDeviceId = 'device_${DateTime.now().millisecondsSinceEpoch}'; // 기기 식별 값
  await FirebaseFirestore.instance.collection('notification_tokens').doc(userDeviceId).set({
    'token': token,
    'createdAt': FieldValue.serverTimestamp(),
  });
}

// FCM 리스너 설정 (알림 활성화/비활성화 상태 반영)
void setupFCMListener(WidgetRef ref) {
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    // 알림 상태를 불러옴
    final isNotificationEnabled = ref.read(notificationProvider);
    if (isNotificationEnabled && message.notification != null) {
      print('🔥 포그라운드 메시지 수신: ${message.notification?.title}');
      showNotification(message); // 알림을 활성화된 경우만 표시
    } else {
      print('알림이 비활성화되어 있어서 알림을 표시하지 않음');
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print('🖱️ 사용자가 알림을 클릭하여 앱을 열었습니다.');
  });

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
}
// 백그라운드에서 메시지 수신 시 실행되는 핸들러
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  final isNotificationEnabled = await checkNotificationStatus();
  if (isNotificationEnabled && message.notification != null) {
    showNotification(message);
  } else {
    print('알림이 비활성화되어 있어 백그라운드에서 푸시 알림을 표시하지 않음');
  }
}


Future<void> showNotification(RemoteMessage message) async {
  print('🔔 알림 표시: ${message.notification?.title}');

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

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

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
// 알림 설정 상태를 확인하는 함수
Future<bool> checkNotificationStatus() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('notification_enabled') ?? false;
}

// 알림 설정 함수
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

// 앱 초기화 상태 및 로딩 처리
class _MyAppState extends ConsumerState<MyApp> with WidgetsBindingObserver {
  bool _isInitialized = false; // 앱 초기화 상태
  bool _isLoading = true; // 로딩 상태

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); // 앱 라이프사이클 감시자 추가
    _initializeApp();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // 앱 라이프사이클 감시자 제거
    super.dispose();
  }

  // 앱 초기화 메서드
  Future<void> _initializeApp() async {
    await Future.delayed(const Duration(seconds: 3)); // 3초 딜레이
    setState(() {
      _isInitialized = true;
      _isLoading = false; // 로딩 완료
    });
    // 알림 설정 불러오기
    setupFCMListener(ref);
    await AdManager.initialize();  // AdMob 초기화

    // ✅ AdPopcorn SSP 초기화 (네이티브 연결 후 실행)
    if (Platform.isAndroid) {
      final androidKey = "118439798";
      if (androidKey.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 500)); // 네이티브 연결 대기
        AdPopcornSSP.init(androidKey);
        // AdPopcornSSP.setLogLevel("Trace");
      } else {
        debugPrint("❌ Android AdPopcornSSP Key is missing!");
      }
    } else if (Platform.isIOS) {
      final iosKey = '603898345';
      if (iosKey.isNotEmpty) {
        await Future.delayed(Duration(milliseconds: 500)); // 네이티브 연결 대기
        AdPopcornSSP.init(iosKey);
        AdPopcornSSP.setLogLevel("Trace");
      } else {
        debugPrint("❌ iOS AdPopcornSSP Key is missing!");
      }
    }
    // AdPopcornSSP.loadInterstitial('118439798', 'V247cLQwngSgnN4');
    // AdPopcornSSP.interstitialAdLoadSuccessListener = (placementId) {
    //   print('Interstitial Ad 로드: $placementId');
    //   AdPopcornSSP.showInterstitial('118439798', 'V247cLQwngSgnN4');
    // };
    // AdPopcornSSP.interstitialAdLoadFailListener = (placementId, error) {
    //   print('Interstitial Ad 실패: $placementId, Error: $error');
    // };
    // 전면 광고 로드
    AdPopcornInterstitialUtil().initialize();
  }

  // 앱 라이프사이클 상태 변화 감지
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // 앱이 백그라운드에서 다시 포그라운드로 돌아올 때 동작
      if (!_isInitialized) {
        _initializeApp(); // 필요 시 재초기화
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final goRouter = ref.watch(goRouterProvider); // GoRouter를 감시하여 화면 이동 처리

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        if (_isLoading) {
          // 앱이 로딩 중일 때 스플래시 화면 표시
          return const SplashScreen();
        }

        // 앱이 초기화 완료되면 MaterialApp을 반환
        return MaterialApp.router(
          routerConfig: goRouter, // GoRouter 설정
          title: 'Cookfluencer',
          theme: AppTheme.light().copyWith(
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: {
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // iOS 뒤로가기 제스처 허용
                TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(), // Android 애니메이션 설정
              },
            ),
          ),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
        );
      },
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // 텍스트 방향 설정
      child: Scaffold(
        backgroundColor: AppColors.splashBackground, // 배경색 설정
        body: Center(
          child: Image.asset(
            Assets.splash,
            fit: BoxFit.cover, // 부모 위젯을 가득 채우도록 설정
          ),
        ),
      ),
    );
  }
}