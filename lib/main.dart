import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/constant/app_theme.dart';
import 'package:cookfluencer/firebase_options.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  // Flutter 바인딩을 초기화합니다.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Future<void> clearPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.clear(); // 모든 SharedPreferences 데이터 삭제
  //   print('All SharedPreferences cleared.');
  // }
  // clearPreferences();
  runApp(const ProviderScope(child: MyApp())); // Riverpod ProviderScope 추가
}


class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    return MaterialApp.router(
      routerConfig: goRouter,
      title: 'Flutter Demo',
      theme: AppTheme.light(),  // AppTheme의 light 테마 적용
    );
  }
}

