import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../repository/KakaoAuthRepository.dart';
import '../repository/FirebaseTokenRepository.dart';

/// ✅ 사용자 상태 관리 (로그인 정보 + Firestore 사용자 데이터 + 로딩 상태)
class AuthState {
  final firebase_auth.User? user;
  final Map<String, dynamic>? userData;
  final bool isLoading;

  AuthState({this.user, this.userData, this.isLoading = false});

  AuthState copyWith({
    firebase_auth.User? user,
    Map<String, dynamic>? userData,
    bool? isLoading,
  }) {
    return AuthState(
      user: user ?? this.user,
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final KakaoAuthRepository kakaoAuth;
  final FirebaseTokenRepository tokenRepo;

  AuthNotifier(this.kakaoAuth, this.tokenRepo)
      : super(AuthState(user: firebase_auth.FirebaseAuth.instance.currentUser)) {
    _initializeAuthState();
  }

  /// ✅ Firebase Auth 상태 감지 및 Firestore 데이터 한 번만 불러오기
  void _initializeAuthState() async {
    final user = firebase_auth.FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await _fetchUserData(user.uid);
      state = AuthState(user: user, userData: userData, isLoading: false);
    }
  }

  /// ✅ Firestore에서 사용자 정보 가져오기 (캐싱)
  Future<Map<String, dynamic>?> _fetchUserData(String uid) async {
    final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  /// ✅ 카카오 로그인 (UI 리빌딩 없이 로그인 상태만 변경)
  Future<void> loginWithKakao() async {
    if (state.isLoading) return; // 중복 실행 방지
    state = AuthState(user: state.user, userData: state.userData, isLoading: true);

    try {
      final userCredential = await kakaoAuth.loginWithKakao();
      if (userCredential != null) {
        final user = firebase_auth.FirebaseAuth.instance.currentUser;
        if (user != null) {
          final userData = await _fetchUserData(user.uid);
          state = AuthState(user: user, userData: userData, isLoading: false);
        }
      }
    } catch (e) {
      state = AuthState(user: state.user, userData: state.userData, isLoading: false);
    }
  }

  /// ✅ 로그아웃 기능 (UI 깜빡임 없이 처리)
  Future<void> logout() async {
    state = AuthState(user: state.user, userData: state.userData, isLoading: true);

    await tokenRepo.removeFCMToken();
    await kakaoAuth.logout();
    await firebase_auth.FirebaseAuth.instance.signOut();

    state = AuthState(user: null, userData: null, isLoading: false);
  }
}

/// ✅ 로그인 상태를 관리하는 Riverpod Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(KakaoAuthRepository(), FirebaseTokenRepository());
});