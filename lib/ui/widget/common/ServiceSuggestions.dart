import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/ui/widget/common/CustomRoundButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';

class Servicesuggestions extends StatelessWidget {
  const Servicesuggestions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.width(context, 1),
      // height: ScreenUtil.height(context, 0.26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12), // 둥근 테두리 설정
        color: AppColors.primaryColor // 배경 색상
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 32),
            child: Center(
              child: Text('서비스 개선에 함께하세요',
                style: TextStyle(
                  fontSize: 18,
                  color: AppColors.black,
                  fontFamily: GoogleFonts.nanumGothic().fontFamily,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Center(
              child: Text('기능이나 레시피에 대한 새로운 아이디어가\n있으신가요? 내용을 공유해주세요!',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.black,
                fontFamily: GoogleFonts.nanumGothic().fontFamily,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(top: 32),
          child: Center(

            child: Padding(
              padding: const EdgeInsets.only(left:20,right: 20 ,bottom: 32 ),
              child: CustomRoundButton(text: '아이디어 제출', onTap: () {
                // 아이디어 제출 버튼 클릭 시 동작
              }),
            ),
          ),
        ),
        ],
      ),
    );
  }
}
