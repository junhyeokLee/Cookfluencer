import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart' as kakao;

class KakaoAuthRepository {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  /// 카카오 로그인 → Firebase 연동
  Future<firebase_auth.UserCredential?> loginWithKakao() async {
    try {
      kakao.OAuthToken token;

      if (await kakao.isKakaoTalkInstalled()) {
        token = await kakao.UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await kakao.UserApi.instance.loginWithKakaoAccount();
      }

      final kakaoUser = await kakao.UserApi.instance.me();

      if (token.idToken == null) {
        print("⚠️ 경고: 카카오 ID 토큰이 null입니다. Firebase 인증이 실패할 수 있습니다.");
      }

      // ✅ ID 토큰이 없으면 액세스 토큰을 사용하도록 변경
      final firebase_auth.AuthCredential credential =
      firebase_auth.OAuthProvider("oidc.kakao.com").credential(
        idToken: token.idToken ?? "",  // ✅ ID 토큰이 null이면 빈 값 전달
        accessToken: token.accessToken, // ✅ 액세스 토큰 사용
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await saveUserDataToFirestore(userCredential.user!, kakaoUser);
      }

      return userCredential;
    } catch (error) {
      print("❌ 카카오 로그인 실패: $error");
      return null;
    }
  }

  /// 로그아웃
  Future<void> logout() async {
    print("🔄 로그아웃 시도...");
    await _auth.signOut();
    try {
      await kakao.UserApi.instance.logout();
      print("✅ 카카오 로그아웃 성공");
    } catch (error) {
      print("❌ 카카오 로그아웃 실패: $error");
    }
  }

  /// 현재 로그인된 Firebase 사용자 가져오기
  firebase_auth.User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Firestore에 사용자 데이터 저장 (카카오 유저 ID 포함)
  Future<void> saveUserDataToFirestore(firebase_auth.User user, kakao.User kakaoUser) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDoc.set({
      'uid': user.uid,
      'kakaoId': kakaoUser.id.toString(), // ✅ 카카오 고유 ID 저장
      'email': user.email ?? '', // ✅ 카카오에서 이메일 제공 안 하면 빈 값
      'nickname': kakaoUser.kakaoAccount?.profile?.nickname ?? '사용자', // ✅ 닉네임
      'photoURL': kakaoUser.kakaoAccount?.profile?.profileImageUrl ?? "", // ✅ 프로필 이미지
      'phoneNumber': kakaoUser.kakaoAccount?.phoneNumber ?? '', // ✅ 전화번호
      'gender': kakaoUser.kakaoAccount?.gender?.name ?? '', // ✅ 성별 (male/female)
      'birthday': kakaoUser.kakaoAccount?.birthday ?? '', // ✅ 생일 (MMDD 형식)
      'createdAt': FieldValue.serverTimestamp(), // ✅ 가입 시간
    }, SetOptions(merge: true));

    print("✅ Firestore에 사용자 정보 저장 완료");


    // ✅ FCM 토큰 가져오기
    final fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      final tokenDoc = FirebaseFirestore.instance
          .collection("notification_tokens")
          .doc(fcmToken); // ✅ 토큰 자체를 문서 ID로 사용 (중복 방지)

      await tokenDoc.set({
        'token': fcmToken,
        'userId': user.uid,
        'sub_channel': false, // ✅ 기본값 false로
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("✅ FCM 토큰 저장 완료 (sub_channel: false)");
    } else {
      print("⚠️ FCM 토큰을 가져오지 못했습니다.");
    }

  }
}