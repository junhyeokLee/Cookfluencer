import 'dart:io';
import 'package:adpopcornssp_flutter/adpopcornssp_flutter.dart';

class AdPopcornInterstitialUtil {
  // 싱글톤 패턴으로 전면 광고 관리
  static final AdPopcornInterstitialUtil _instance = AdPopcornInterstitialUtil._internal();
  factory AdPopcornInterstitialUtil() => _instance;AdPopcornInterstitialUtil._internal();

  final String appKey = Platform.isAndroid ? '118439798' : '603898345';
  final String placementId = Platform.isAndroid ? "V247cLQwngSgnN4" : "rrFL3ekzxetDbd0";

  // 초기화 함수
  void initialize() {
    AdPopcornSSP.setLogLevel("Trace"); // 로그 레벨 설정
    AdPopcornSSP.loadInterstitial(appKey, placementId);
    // 광고 로드 성공 시 바로 표시
    AdPopcornSSP.interstitialAdLoadSuccessListener = (placementId) {
      print('Interstitial Ad Loaded: $placementId');
      AdPopcornSSP.showInterstitial(appKey, placementId);
    };
    // 광고 로드 실패 로그 출력
    AdPopcornSSP.interstitialAdLoadFailListener = (placementId, error) {
      print('Interstitial Ad Failed: $placementId, Error: $error');
    };
  }
}