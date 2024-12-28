import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/app_theme.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/firebase_options.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

// Firebase 초기화 및 앱 시작
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

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
    await Future.delayed(const Duration(seconds: 3)); // 2초 딜레이
    setState(() {
      _isInitialized = true;
      _isLoading = false; // 로딩 완료
    });
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

// class SplashScreen extends StatelessWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.ltr, // 텍스트 방향 설정
//       child: Scaffold(
//         backgroundColor: AppColors.primaryColor, // 배경색 설정
//         body: Center(
//           child: Lottie.asset(
//             'assets/main.json',
//             repeat: false, // 애니메이션 반복 안 함
//             alignment: Alignment.center, // 정렬 설정
//             fit: BoxFit.contain,
//             frameRate: FrameRate.max, // 최대 프레임 설정
//             filterQuality: FilterQuality.high, // 필터 품질 설정
//             frameBuilder: (context, child, composition) {
//               return AnimatedOpacity(
//                 child: child,
//                 opacity: composition == null ? 0 : 1, // 애니메이션 투명도 설정
//                 duration: const Duration(milliseconds: 500), // 애니메이션 지속 시간
//                 curve: Curves.easeInOut, // 애니메이션 커브
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }