import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomRoundButton extends StatelessWidget {
  final String text;
  final bool isEnabled;
  final Function() onTap;
  final double? width;
  final double height;
  final double? borderRadius;
  final double fontSize;
  final Color textColor;
  final Color bgColor;
  final FontWeight fontWeight;
  final Widget? leftIcon; // 왼쪽 아이콘
  final Widget? rightIcon; // 오른쪽 아이콘
  final EdgeInsetsGeometry padding; // 버튼 패딩

  const CustomRoundButton({
    super.key,
    required this.text,
    required this.onTap,
    this.isEnabled = false,
    this.width,
    this.height = 40.0,
    this.borderRadius,
    this.fontSize = 14,
    this.textColor = Colors.white,
    this.bgColor = AppColors.primarySelectedColor,
    this.fontWeight = FontWeight.w700,
    this.leftIcon,
    this.rightIcon,
    this.padding = const EdgeInsets.symmetric(horizontal: 16), // 기본 패딩 설정
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isEnabled ? bgColor : AppColors.primarySelectedColor,
      borderRadius: BorderRadius.circular(borderRadius ?? height / 2), // 둥근 모서리
      child: InkWell(
        onTap: isEnabled ? onTap : () {
          onTap();
        }, // 활성화 상태에서만 클릭 가능
        splashColor: AppColors.grey.withOpacity(0.5),
        highlightColor: AppColors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(borderRadius ?? height / 2),
        child: Container(
          width: width ?? double.infinity, // 너비 설정
          height: height,
          padding: padding,
          alignment: Alignment.center, // 중앙 정렬
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leftIcon != null) ...[
                leftIcon!,
                const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
              ],
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: fontSize,
                  fontFamily: GoogleFonts.notoSans().fontFamily, // Google Font 사용 (Noto Sans
                  fontWeight: fontWeight,
                ),
              ),
              if (rightIcon != null) ...[
                const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                rightIcon!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}