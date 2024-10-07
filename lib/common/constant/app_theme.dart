import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // 1
  static TextTheme textTheme =  TextTheme(
    labelLarge: GoogleFonts.notoSans(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black,),
    labelMedium: GoogleFonts.notoSans(
        fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.black),
    labelSmall: GoogleFonts.notoSans(
        fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.black),
    bodyLarge: GoogleFonts.notoSans(
        fontSize: 14.sp, fontWeight: FontWeight.w400, color: Colors.black),
    bodyMedium: GoogleFonts.notoSans(
        fontSize: 13.sp, fontWeight: FontWeight.w400, color: Colors.black),
    bodySmall: GoogleFonts.notoSans(
        fontSize: 12.sp, fontWeight: FontWeight.w400, color: Colors.black),
    titleLarge: GoogleFonts.notoSans(
        fontSize: 18.sp, fontWeight: FontWeight.w700, color: Colors.black),
    titleMedium: GoogleFonts.notoSans(
        fontSize: 16.sp, fontWeight: FontWeight.w700, color: Colors.black),
    titleSmall: GoogleFonts.notoSans(
        fontSize: 14.sp, fontWeight: FontWeight.w700, color: Colors.black),
  );

  // 3
  static light() {
    return ThemeData(
      useMaterial3: true,
      textTheme: textTheme,
      fontFamily: GoogleFonts.notoSans().fontFamily,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(32.0),
            ),
          ),
          backgroundColor: Colors.black87,
          foregroundColor: Colors.white),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: Colors.white,
        // 원하는 배경색으로 변경
        indicatorColor: Colors.white,
        labelTextStyle: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return TextStyle(
              fontSize: 12.sp,
              fontFamily: GoogleFonts.notoSans().fontFamily,
              fontWeight: FontWeight.w400,
              color: Colors.black, // 선택 텍스트 색상
            );
          }
          return TextStyle(
            fontSize: 12.sp,
            fontFamily: GoogleFonts.notoSans().fontFamily,
            fontWeight: FontWeight.w400,
            color: AppColors.greyDeep, // 선택되지 않은 텍스트 색상
          );
        }),
        iconTheme: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return IconThemeData(
              size: 30,
              color: Colors.black, // 선택된 아이콘 색상
            );
          }
          return IconThemeData(
            size: 24.w,
            color: Colors.black, // 선택되지 않은 아이콘 색상
          );
        }),
      ),
      colorScheme: const ColorScheme.light().copyWith(
        primary: Colors.white,
        secondary: Colors.black87,
        brightness: Brightness.light,
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all<Size>(
            const Size(40, 40),
          ),
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.grey; // 비활성화된 버튼의 배경색
            }
            return AppColors.greyBackground; // 활성화된 버튼의 배경색
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return AppColors.black; // 비활성화된 버튼의 텍스트 색상
            }
            return AppColors.black; // 활성화된 버튼의 텍스트 색상
          }),
        ),
      ),


      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        scrolledUnderElevation: 0, // 스크롤시 색변경 이슈
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        // titleSpacing: 0.0,
        elevation: 0,
        centerTitle: false,
        toolbarHeight: 54,
      ),

      inputDecorationTheme: const InputDecorationTheme(
        labelStyle: TextStyle(color: Colors.black45),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 2.0,
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 2.0,
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            style: BorderStyle.solid,
            width: 1.0,
            color: Colors.black87,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
      ),

      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.veryDarkGrey,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
