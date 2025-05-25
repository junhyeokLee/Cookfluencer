import 'dart:io';
import 'package:adpopcornssp_flutter/adpopcornssp_flutter.dart';

class AdPopcornInterstitialVideoUtil {
  static final AdPopcornInterstitialVideoUtil _instance = AdPopcornInterstitialVideoUtil._internal();
  factory AdPopcornInterstitialVideoUtil() => _instance;
  AdPopcornInterstitialVideoUtil._internal();

  final String appKey = Platform.isAndroid ? '118439798' : '603898345';
  final String placementId = Platform.isAndroid ? "UmHUWcR2IUlxSv4" : "qfFOIyBmuIfHHQA";

  bool _isAdLoaded = false;

  void initialize() {
    AdPopcornSSP.setLogLevel("Trace");

    // 광고 로드 시작
    AdPopcornSSP.loadInterstitialVideo(appKey, placementId);

    // 광고 로드 성공 시
    AdPopcornSSP.interstitialVideoAdLoadSuccessListener = (loadedPlacementId) {
      print('✅ Interstitial Ad Loaded: $loadedPlacementId');
      if (loadedPlacementId == placementId) {
        _isAdLoaded = true;
        // ✅ 광고 즉시 표시
        AdPopcornSSP.showInterstitialVideo(appKey, placementId);
      }
    };

    // 광고 로드 실패 시
    AdPopcornSSP.interstitialVideoAdLoadFailListener = (failedPlacementId, errorCode) {
      print('❌ Interstitial Ad Failed: $failedPlacementId, Error: $errorCode');
      _isAdLoaded = false;
    };

    // 광고 닫힘 이벤트 (광고가 끝났거나 유저가 닫았을 때)
    AdPopcornSSP.interstitialVideoAdClosedListener = (closedPlacementId) {
      print('ℹ️ Interstitial Ad Closed: $closedPlacementId');
      _isAdLoaded = false;
    };
  }
}
