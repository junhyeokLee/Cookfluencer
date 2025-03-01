import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget setNativeView() {
  const String viewType = 'AdPopcornSSPNativeView';
  if (Platform.isAndroid) {
    final Map<String, dynamic> creationParams = <String, dynamic>
    {'appKey':'118439798', 'placementId':'rcVRhmJu23e2vWV', 'height':160.w};
    return Container(
      width: double.maxFinite,
      height:160.w,
      child: AndroidView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
  else if (Platform.isIOS) {
    final Map<String, dynamic> creationParams = <String, dynamic>
    {'appKey':'603898345', 'placementId':'PjYtjlqk8JvnK1x'};
    return Container(
      width: double.maxFinite,
      height:280,
      child: UiKitView(
        viewType: viewType,
        layoutDirection: TextDirection.ltr,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      ),
    );
  }
  else{
    return Container(
        width: double.maxFinite,
        height: 1
    );
  }
}