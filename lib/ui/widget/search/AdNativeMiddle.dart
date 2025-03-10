import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget setNativeMiddleView() {
  const String viewType = 'AdPopcornSSPNativeView';
  if (Platform.isAndroid) {
    final Map<String, dynamic> creationParams = <String, dynamic>
    {'appKey':'118439798', 'placementId':'IM3JlCYWPOuqfw5', 'height':100};
    return Container(
      width: double.maxFinite,
      height:100.w,
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
    {'appKey':'603898345', 'placementId':'413yNnzh8t6pCXy','height':100};
    return Container(
      width: double.maxFinite,
      height:100.w,
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