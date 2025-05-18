import 'package:cookfluencer/ui/screen/MyPageScreen.dart';
import 'package:flutter/material.dart';
import '../../common/constant/app_colors.dart';
import '../../common/constant/assets.dart';
import '../../repository/KakaoAuthRepository.dart';
import 'HomeScreen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final KakaoAuthRepository _authRepository = KakaoAuthRepository();

  bool _isLoading = false; // 로그인 시 로딩 상태 관리

  /// 🔐 카카오 로그인 핸들러
  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
    });

    print("🔄 로그인 버튼 클릭됨, 카카오 로그인 시작...");
    final userCredential = await _authRepository.loginWithKakao();

    setState(() {
      _isLoading = false;
    });

    if (userCredential != null) {
      print("✅ 로그인 성공! 홈 화면으로 이동");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => MyPageScreen()), // ✅ 홈 화면으로 이동
            (route) => false, // 모든 이전 화면 제거
      );
    } else {
      print("❌ 로그인 실패!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("카카오 로그인 실패! 다시 시도해주세요.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 💡 배경색은 흰색으로 깔끔하게
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🔵 로고나 앱 아이덴티티 영역
                Image.asset(
                  Assets.logo, // 앱 로고 이미지 (필요 시 교체)
                  width: 120,
                  height: 120,
                ),
                const SizedBox(height: 24),
                const Text(
                  "나만의 쿡플루언서 채널 구독 관리 앱",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "카카오 로그인으로 간편하게 시작해보세요!",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 40),

                // ✅ 카카오 로그인 버튼
                _isLoading
                    ? const CircularProgressIndicator() // 로딩 표시
                    : SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    icon: Image.asset(
                      Assets.kakaoLogo,
                      width: 24,
                      height: 24,
                    ),
                    label: const Text(
                      "카카오로 로그인",
                      style: TextStyle(
                        color: Colors.black, // 카카오 스타일: 검은 글씨
                        fontSize: 16,
                      ),
                    ),
                    onPressed: _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.kakaoYellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}