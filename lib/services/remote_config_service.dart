// lib/services/remote_config_service.dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

/// Firebase Remote Config에서 설정한 파라미터 값을 가져오기 위한 서비스 클래스
class RemoteConfigService {
  final FirebaseRemoteConfig remoteConfig;

  RemoteConfigService({required this.remoteConfig});

  /// Remote Config 초기화 및 기본값 설정 메소드
  Future<void> initialize() async {
    // 디버깅 시 minimumFetchInterval을 0으로 설정하면 최신 값을 바로 가져올 수 있음
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      minimumFetchInterval: Duration(seconds: 0), // 디버그 시 즉시 업데이트
      fetchTimeout: Duration(seconds: 10), // 데이터 fetch 제한 시간, 적절한 값 선택
    ));

    // 기본값 설정: Remote Config에 값이 없을 때 사용할 값들
    await remoteConfig.setDefaults(<String, dynamic>{
      'min_app_version_android': '1.0.0', // 안드로이드 최소 요구 버전
      'min_app_version_ios': '1.0.0',     // iOS 최소 요구 버전
      'force_update_message': '새로운 버전이 나왔습니다. 업데이트 해주세요.',
      'force_update_url_android': 'https://play.google.com/store/apps/details?id=com.devsheep.cookfluencer',
      'force_update_url_ios': 'https://apps.apple.com/app/6737149961',
    });

    // Remote Config의 값을 서버에서 가져와 활성화
    try {
      await remoteConfig.fetchAndActivate();
      print("Remote Config 업데이트 성공");
    } catch (e) {
      print('RemoteConfig fetch 실패: $e');
    }
  }

  /// 플랫폼에 따른 최소 앱 버전 반환 (안드로이드, iOS)
  String getMinAppVersion(String platform) {
    if (platform == 'android') {
      return remoteConfig.getString('min_app_version_android');
    } else {
      return remoteConfig.getString('min_app_version_ios');
    }
  }

  /// 강제 업데이트 메시지 반환
  String getForceUpdateMessage() {
    return remoteConfig.getString('force_update_message');
  }

  /// 플랫폼에 따른 업데이트 URL 반환 (앱스토어/플레이스토어)
  String getForceUpdateUrl(String platform) {
    if (platform == 'android') {
      return remoteConfig.getString('force_update_url_android');
    } else {
      return remoteConfig.getString('force_update_url_ios');
    }
  }
}
