import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

Widget setAdBannerBottom() {
  const String viewType = 'AdPopcornSSPBannerView';
  if (Platform.isAndroid) {
    final Map<String, dynamic> creationParams = <String, dynamic>
    {'appKey':'118439798', 'placementId':'uJH5n6F2KDVKLpd', 'bannerSize':'320x50'};
    return Container(
      width: double.maxFinite,
      height:50,
      child: AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          debugPrint("AdPopcornSSP 광고 뷰가 생성되었습니다. View ID: $id");
        },
      ),
    );
  }
  else if (Platform.isIOS) {
    final Map<String, dynamic> creationParams = <String, dynamic>
    {'appKey':'603898345', 'placementId':'paFyULec1Pd0ij0', 'bannerSize':'320x50'};
    // bannerSize 320x50 300x250 320x100 AdaptiveSize 배너 사이즈 종류
    return Container(
      width: double.maxFinite,
      height:50,
      child: UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        onPlatformViewCreated: (int id) {
          debugPrint("AdPopcornSSP 광고 뷰가 생성되었습니다. View ID: $id");
        },
      ),
    );
  }
  else{
    return SizedBox.shrink();
  }
}