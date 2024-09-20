import 'package:flutter/material.dart';

class ScreenUtil {
  // 화면 너비의 비율을 쉽게 계산하는 함수
  static double width(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.width * ratio;
  }

  // 화면 높이의 비율을 쉽게 계산하는 함수
  static double height(BuildContext context, double ratio) {
    return MediaQuery.of(context).size.height * ratio;
  }

  // 세로, 가로 비율을 동시에 처리할 수 있는 함수
  static double responsiveSize(BuildContext context, {required double widthRatio, required double heightRatio}) {
    final screenSize = MediaQuery.of(context).size;
    return screenSize.width * widthRatio + screenSize.height * heightRatio;
  }

  // 폰트 크기 비율 계산을 위한 함수 (ex: 폰트 크기 스케일링)
  static double textScale(BuildContext context, double factor) {
    return MediaQuery.of(context).textScaleFactor * factor;
  }
}