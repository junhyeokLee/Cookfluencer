import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../common/util/AdManager.dart';

class AdNative150 extends StatefulWidget {

  const AdNative150({super.key});

  @override
  State<AdNative150> createState() => _NativeAdWrapperState();
}

class _NativeAdWrapperState extends State<AdNative150> {
  bool _useAdMob = false; // AdMob으로 전환 여부
  bool _adMobLoaded = false; // AdMob 로드 성공 여부
  bool _hasAd = true; // 기본값 광고 있음

  static const MethodChannel androidNativeChannel = MethodChannel('adpopcornssp/rcVRhmJu23e2vWV');
  static const MethodChannel iosNativeChannel = MethodChannel('adpopcornssp/PjYtjlqk8JvnK1x');

  @override
  void initState() {
    super.initState();
    _initAd();
  }

  void _initAd() {
    if (Platform.isAndroid) {
      androidNativeChannel.setMethodCallHandler(_eventHandleMethod);
    } else if (Platform.isIOS) {
      iosNativeChannel.setMethodCallHandler(_eventHandleMethod);
    }
  }

  Future<dynamic> _eventHandleMethod(MethodCall call) async {
    final Map<dynamic, dynamic> arguments = call.arguments;
    final String method = call.method;

    final String placementId = arguments['placementId'];
    if (method == 'APSSPNativeAdLoadSuccess') {
      setState(() {
        _hasAd = true;
        _useAdMob = false; // 성공 시 AdMob 전환 해제
      });
      debugPrint('✅ AdPopcorn 네이티브 상세 로드 성공');
    } else if (method == 'APSSPNativeAdLoadFail') {
      final int errorCode = arguments['errorCode'];
      debugPrint('🚫 AdPopcorn 네이티브 상세 로드 실패: $errorCode');
      // AdMob 네이티브로 전환
      _switchToAdMob();
    } else if (method == 'APSSPNativeAdImpression') {
    } else if (method == 'APSSPNativeAdClicked') {
    }
    return Future<dynamic>.value(null);
  }

  void _switchToAdMob() {
    debugPrint('🔄 AdMob 네이티브 상세 전환 시도');
    setState(() {
      _useAdMob = true;
      _hasAd = true;
    });
    AdManager.loadAdMobNative150((success) {
      setState(() {
        _adMobLoaded = success;
        if (!success) _hasAd = false; // AdMob도 실패 시 숨김
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasAd) return const SizedBox.shrink();

    if (_useAdMob) {
      final ad = AdManager.adMobNative;
      if (_adMobLoaded && ad != null) {
        return Container(
          width: double.infinity,
          height: 100,
          child: AdWidget(ad: ad),
        );
      } else {
        return const SizedBox.shrink();
      }
    }

    return _buildAdPopcornNativeView();

  }
  /// AdPopcorn 네이티브 광고 뷰 반환
  Widget _buildAdPopcornNativeView() {
    const viewType = 'AdPopcornSSPNativeView';
    final creationParams = {
      'appKey': Platform.isAndroid ? '118439798' : '603898345',
      'placementId': Platform.isAndroid ? 'rcVRhmJu23e2vWV' : 'PjYtjlqk8JvnK1x',
      'height': 150,
    };

    if (Platform.isAndroid) {
      return Container(
        width: double.infinity,
        height: 150,
        child: AndroidView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            debugPrint('📡 AdPopcorn 네이티브 뷰 생성 완료 (Android), View ID: $id');
          },
        ),
      );
    } else if (Platform.isIOS) {
      return Container(
        width: double.infinity,
        height: 150,
        child: UiKitView(
          viewType: viewType,
          layoutDirection: TextDirection.ltr,
          creationParams: creationParams,
          creationParamsCodec: const StandardMessageCodec(),
          onPlatformViewCreated: (id) {
            debugPrint('📡 AdPopcorn 네이티브 뷰 생성 완료 (iOS), View ID: $id');
          },
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

}