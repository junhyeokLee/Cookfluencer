import 'dart:io';
import 'package:adpopcornssp_flutter/adpopcornssp_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/AuthChecker.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/app_theme.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/firebase_options.dart';
import 'package:cookfluencer/repository/KakaoAuthRepository.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:cookfluencer/services/firebase_notifications.dart';
import 'package:cookfluencer/ui/screen/HomeScreen.dart';
import 'package:cookfluencer/ui/screen/LoginScreen.dart';
import 'package:cookfluencer/util/AdPopcornInterstitialUtil.dart';
import 'package:cookfluencer/util/AdPopcornInterstitialVideoUtil.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth; // Firebase Auth 별칭 추가
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao; // Kakao SDK 별칭 추가
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../provider/NotificationProvider.dart';
import 'common/util/AdManager.dart';

// Firebase 초기화 및 앱 시작
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await dotenv.load(); // .env 쓰는 경우
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  KakaoSdk.init(nativeAppKey: "87ab621c8be7408e618e3f12007ec9ae");
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  ConsumerState<MyApp> createState() => _MyAppState();
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
    // setupFCMListener(ref);
    setupFirebaseMessaging(ref); // 이거 하나면 끝!
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
    AdPopcornInterstitialVideoUtil().initialize();
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