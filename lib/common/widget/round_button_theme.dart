import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

enum RoundButtonTheme {
  grey(AppColors.greyBackground, AppColors.grey, AppColors.greyBackground, backgroundColorProvider: blueColorProvider),
  whiteWithBlueBorder(Colors.grey, AppColors.greyBackground, AppColors.greyBackground,
      backgroundColorProvider: blueColorProvider),
  blink(AppColors.greyBackground, AppColors.grey, AppColors.greyBackground, backgroundColorProvider: blueColorProvider);

  const RoundButtonTheme(
    this.bgColor,
    this.textColor,
    this.borderColor, {
    this.backgroundColorProvider,
  }) : shadowColor = Colors.transparent;

  ///RoundButtonTheme 안에서 Custome Theme 분기가 필요하다면 이렇게 함수로 사용
  final Color Function(BuildContext context)? backgroundColorProvider;
  final Color bgColor;
  final Color textColor;
  final Color borderColor;
  final Color shadowColor;
}

Color blueColorProvider(BuildContext context) => AppColors.greyBackground;

Color Function(BuildContext context) defaultColorProvider(Color color) => blueColorProvider;
