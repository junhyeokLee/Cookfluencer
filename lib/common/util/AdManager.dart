import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../constant/app_colors.dart';

class AdManager {
  static BannerAd? _adMobBanner;
  static NativeAd? _adMobNative;
  static NativeAd? _adMobNativeBottom;

  static Future<void> initialize() async {
    await MobileAds.instance.initialize();
  }

  static void loadAdMobBanner(Function(bool) onComplete) {
    _adMobBanner = BannerAd(
      adUnitId: Platform.isIOS ? 'ca-app-pub-1438205576140129/5049701604' : 'ca-app-pub-1438205576140129/1618589025',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          print('✅ AdMob 배너 로드 성공');
          onComplete(true);
        },
        onAdFailedToLoad: (ad, error) {
          print('🚫 AdMob 배너 로드 실패: $error');
          ad.dispose();
          onComplete(false);
        },
      ),
    )..load();
  }

  static void loadAdMobNative150(Function(bool) onComplete) {
    _adMobNative = NativeAd(
      adUnitId: Platform.isIOS ? 'ca-app-pub-1438205576140129/1754288579' : 'ca-app-pub-1438205576140129/7782578676',
      factoryId: null,
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        cornerRadius: 12,
        mainBackgroundColor: AppColors.backgroundColor,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColors.primarySelectedColor,
          size: 16,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.primarySelectedColor,
          size: 14,
        ),
      ),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('✅ AdMob 네이티브 상세 로드 성공');
          onComplete(true);
        },
        onAdFailedToLoad: (ad, error) {
          print('🚫 AdMob 네이티브 상세 로드 실패: $error');
          ad.dispose();
          onComplete(false);
        },
      ),
    )..load();
  }
  static void loadAdMobNative(Function(bool) onComplete) {
    _adMobNative = NativeAd(
      adUnitId: Platform.isIOS ? 'ca-app-pub-1438205576140129/8276568545' : 'ca-app-pub-1438205576140129/1587037112',
      factoryId: null,
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        cornerRadius: 12,
        mainBackgroundColor: AppColors.backgroundColor,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColors.primarySelectedColor,
          size: 16,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.primarySelectedColor,
          size: 14,
        ),
      ),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('✅ AdMob 네이티브 로드 성공');
          onComplete(true);
        },
        onAdFailedToLoad: (ad, error) {
          print('🚫 AdMob 네이티브 로드 실패: $error');
          ad.dispose();
          onComplete(false);
        },
      ),
    )..load();
  }

  static void loadAdMobNativeBottom(Function(bool) onComplete) {
    _adMobNativeBottom = NativeAd(
      adUnitId: Platform.isIOS ? 'ca-app-pub-1438205576140129/3805768662' : 'ca-app-pub-1438205576140129/1371177019',
      factoryId: null,
      nativeTemplateStyle: NativeTemplateStyle(
        templateType: TemplateType.small,
        cornerRadius: 12,
        mainBackgroundColor: AppColors.backgroundColor,
        callToActionTextStyle: NativeTemplateTextStyle(
          textColor: Colors.white,
          backgroundColor: AppColors.primarySelectedColor,
          size: 16,
        ),
        primaryTextStyle: NativeTemplateTextStyle(
          textColor: AppColors.primarySelectedColor,
          size: 14,
        ),
      ),
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          print('✅ AdMob 네이티브 하단 로드 성공');
          onComplete(true);
        },
        onAdFailedToLoad: (ad, error) {
          print('🚫 AdMob 네이티브 하단 로드 실패: $error');
          ad.dispose();
          onComplete(false);
        },
      ),
    )..load();
  }

  static BannerAd? get adMobBanner => _adMobBanner;
  static NativeAd? get adMobNative => _adMobNative;
  static NativeAd? get adMobNativeBottom => _adMobNativeBottom;
}