import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../common/util/AdManager.dart';

class AdPopcornBanner extends StatefulWidget {
  const AdPopcornBanner({super.key});

  @override
  State<AdPopcornBanner> createState() => _AdPopcornBannerState();
}

class _AdPopcornBannerState extends State<AdPopcornBanner> {
  bool _hasAd = true; // 기본값은 광고 있음
  bool _useAdMob = false; // AdMob 전환 여부 플래그
  bool _adMobLoaded = false; // AdMob 로드 성공 여부

  // static const methodChannel = MethodChannel('adpopcornssp/banner');
  static const MethodChannel androidBannerChannel = const MethodChannel('adpopcornssp/uJH5n6F2KDVKLpd');
  static const MethodChannel iosBannerChannel = const MethodChannel('adpopcornssp/paFyULec1Pd0ij0');
  @override
  void initState() {
    super.initState();
    _listenForAdEvents();
  }

  void _listenForAdEvents() {
    if (Platform.isAndroid) {
      androidBannerChannel.setMethodCallHandler(_eventHandleMethod);
    } else if (Platform.isIOS) {
      iosBannerChannel.setMethodCallHandler(_eventHandleMethod);
    }
  }

  Future<void> _eventHandleMethod(MethodCall call) async {
    print('_eventHandleMethod: ${call.method}, ${call.arguments}');
    final Map<dynamic, dynamic> arguments = call.arguments;
    final String method = call.method;

    final String placementId = arguments['placementId'];
    if (method == 'APSSPBannerViewLoadSuccess') {
      setState(() {
        _hasAd = true;
        _useAdMob = false; // AdPopcorn 성공 시 AdMob 해제
      });
      debugPrint('✅ AdPopcorn 배너 광고 로드 성공');
    } else if (method == 'APSSPBannerViewLoadFail') {
      final int errorCode = arguments['errorCode'];
      _switchToAdMob(); // AdPopcorn 실패 시 AdMob으로 전환
      debugPrint('🚫 AdPopcorn 배너 광고 로드 실패: $errorCode');
    } else if (method == 'APSSPBannerViewClicked') {
    } else if (method == 'APSSPNativeAdLoadSuccess') {
    } else if (method == 'APSSPNativeAdLoadFail') {
    } else if (method == 'APSSPNativeAdImpression') {
    } else if (method == 'APSSPNativeAdClicked') {
    }
    return Future<dynamic>.value(null);
  }

  /// AdMob으로 전환
  void _switchToAdMob() {
    debugPrint('🔄 AdMob 배너 전환 시도');
    setState(() {
      _useAdMob = true;
      _hasAd = true; // 광고 공간 유지
    });

    AdManager.loadAdMobBanner((success) {
      setState(() {
        _adMobLoaded = success;
        if (!success) {
          _hasAd = false; // AdMob도 실패하면 광고 숨김
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 광고 없으면 공간 차지 안 하도록 shrink
    if (!_hasAd) {
      return const SizedBox.shrink();
    }
    if (_useAdMob) {
      if (_adMobLoaded && AdManager.adMobBanner != null) {
        return Container(
          width: double.infinity,
          height: 50,
          child: AdWidget(ad: AdManager.adMobBanner!),
        );
      } else {
        // AdMob도 실패했으면 아예 광고 영역 숨김
        return const SizedBox.shrink();
      }
    }

    const viewType = 'AdPopcornSSPBannerView';
    final creationParams = {
      'appKey': Platform.isAndroid ? '118439798' : '603898345',
      'placementId': Platform.isAndroid ? 'uJH5n6F2KDVKLpd' : 'paFyULec1Pd0ij0',
      'bannerSize': '320x50',
    };

    if (Platform.isAndroid) {
      return Container(
        width: double.maxFinite,
        height: 50,
        child: AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            debugPrint("AdPopcornSSP 광고 뷰 생성 (Android), View ID: $id");
          },
        ),
      );
    } else if (Platform.isIOS) {
      return Container(
        width: double.maxFinite,
        height: 50,
        child: UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            debugPrint("AdPopcornSSP 광고 뷰 생성 (iOS), View ID: $id");
          },
        ),
      );
    } else {
      return Container(
          width: double.maxFinite,
          height: 1
      );
    }
  }

}