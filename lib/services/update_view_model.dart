// lib/viewmodel/update_view_model.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../services/remote_config_service.dart';

/// 강제 업데이트 여부를 판단하는 ViewModel (MVVM 패턴)
class UpdateViewModel extends ChangeNotifier {
  final RemoteConfigService remoteConfigService;

  bool _forceUpdateRequired = false;
  bool get forceUpdateRequired => _forceUpdateRequired;

  String _updateMessage = '';
  String get updateMessage => _updateMessage;

  String _updateUrl = '';
  String get updateUrl => _updateUrl;

  UpdateViewModel({required this.remoteConfigService});

  /// 버전 문자열 비교 함수: 현재 버전이 최소 요구 버전보다 낮으면 업데이트 필요
  bool isUpdateRequired(String currentVersion, String minVersion) {
    List<int> current = currentVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    List<int> min = minVersion.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    for (int i = 0; i < min.length; i++) {
      if (current.length <= i || current[i] < min[i]) return true;
      else if (current[i] > min[i]) return false;
    }
    return false;
  }

  /// 강제 업데이트 여부 체크 메소드
  Future<void> checkForUpdate() async {
    await remoteConfigService.initialize();

    // 현재 앱 버전 정보 가져오기
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String currentVersion = packageInfo.version;
    print("현재 앱 버전: $currentVersion");

    // 플랫폼 구분: 안드로이드 또는 iOS
    String platform = Platform.isAndroid ? 'android' : 'ios';
    String minVersion = remoteConfigService.getMinAppVersion(platform);
    print("최소 요구 버전: $minVersion");

    if (isUpdateRequired(currentVersion, minVersion)) {
      _forceUpdateRequired = true;
      print("업데이트 필요로 판단됨.");
      _updateMessage = remoteConfigService.getForceUpdateMessage();
      _updateUrl = remoteConfigService.getForceUpdateUrl(platform);
      print("강제 업데이트 필요: $_forceUpdateRequired");
    } else {
      _forceUpdateRequired = false;
      print("업데이트 불필요");
      print("업데이트 불필요로 판단됨.");
    }
    notifyListeners();
  }
}
