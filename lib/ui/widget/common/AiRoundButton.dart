import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Airoundbutton extends StatelessWidget {
  final String text; // 버튼에 표시할 텍스트
  final bool isEnabled; // 버튼 활성화 상태
  final Function() onTap; // 버튼 클릭 시 실행할 함수
  final double height; // 버튼 높이
  final double? borderRadius; // 버튼 모서리 반경
  final double fontSize; // 글자 크기
  final Color textColor; // 글자 색상
  final FontWeight fontWeight; // 글자 두께
  final EdgeInsetsGeometry padding; // 패딩

  const Airoundbutton({
    super.key,
    required this.text,
    required this.onTap,
    this.isEnabled = false, // 기본값: false
    this.height = 45.0,
    this.borderRadius,
    this.fontSize = 14,
    this.textColor = Colors.black,
    this.fontWeight = FontWeight.w700,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    // 비활성화 상태일 때 색상 설정
    Color backgroundColor = isEnabled ? Colors.white : AppColors.keywordBackground;
    Color borderColor = isEnabled ? Colors.transparent : AppColors.keywordBackground;
    Color textColorEffective = isEnabled ? textColor : AppColors.hintText;

    return Container(
      width: double.infinity,
      height: 45.h,
      child: Stack(
        children: [
          // 그라데이션 보더
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(height), // 높이에 맞게 완전한 원형으로 설정
              gradient: isEnabled
                  ? LinearGradient(
                colors: [
                  Color(0xFFC837AB),
                  Color(0xFFFF543E),
                  Color(0xFFFFDD55),
                  Color(0xFFFFDD55),
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              )
                  : null, // 비활성화 상태에서는 그라데이션 없앰
            ),
          ),
          // 내부 배경
          Container(
            margin: const EdgeInsets.all(2), // 여백을 조정하여 보더가 잘리지 않게 설정
            decoration: BoxDecoration(
              color: backgroundColor,
              border: Border.all(color: borderColor, width: 2),
              borderRadius: BorderRadius.circular(borderRadius ?? height), // 완전한 원형으로 설정
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(borderRadius ?? height), // 완전한 원형으로 설정
              child: InkWell(
                onTap: isEnabled ? onTap : null, // 비활성화 시 null
                splashColor: Colors.grey.withOpacity(0.5),
                highlightColor: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.circular(borderRadius ?? height), // 완전한 원형으로 설정
                child: Center(
                  child: Padding(
                    padding: padding,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // 아이콘 처리
                        isEnabled
                            ? ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Color(0xFFC837AB),
                              Color(0xFFFF543E),
                              Color(0xFFFFDD55),
                              Color(0xFFFFDD55),
                            ],
                            tileMode: TileMode.clamp,
                          ).createShader(bounds),
                          child: Image.asset(
                            Assets.creat,
                            width: 24.w,
                            height: 24.h,
                          ),
                        )
                            : ColorFiltered(
                          colorFilter: ColorFilter.mode(
                            Colors.grey, // 비활성화 상태 색상
                            BlendMode.srcIn,
                          ),
                          child: Image.asset(
                            Assets.creat,
                            width: 24.w,
                            height: 24.h,
                          ), // 비활성화 시 회색
                        ),
                        const SizedBox(width: 8),
                        // 텍스트 처리
                        Text(
                          text,
                          style: TextStyle(
                            color: textColorEffective, // 텍스트 색상 조정
                            fontSize: fontSize.sp,
                            fontFamily: GoogleFonts.notoSans().fontFamily,
                            fontWeight: fontWeight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
