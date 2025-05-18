import 'package:flutter/material.dart';
import 'package:cookfluencer/repository/KakaoAuthRepository.dart';
import 'package:cookfluencer/ui/screen/HomeScreen.dart';
import 'package:cookfluencer/ui/screen/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class AuthChecker extends StatelessWidget {
  final KakaoAuthRepository _authRepository = KakaoAuthRepository();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<firebase_auth.User?>(
      stream: firebase_auth.FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("🔄 Firebase 로그인 상태 체크 중...");
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data != null) {
          print("✅ 로그인 감지됨, 홈 화면으로 이동");
          return HomeScreen();
        }
        print("❌ 로그인 안 되어 있음, 로그인 화면으로 이동");
        return LoginScreen();
      },
    );
  }
}