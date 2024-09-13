import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';

class KeywordChip extends StatelessWidget {
  const KeywordChip({
    Key? key,
    required this.keyword, // 키워드 텍스트
    required this.isSelected, // 선택 여부
    required this.onTap, // 선택 시 호출될 함수
  }) : super(key: key);

  final String keyword; // 키워드 이름
  final bool isSelected; // 선택 상태
  final VoidCallback onTap; // 선택 시 동작

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 선택 시 동작 실행
      child: Container(
        margin: const EdgeInsets.only(right: 8), // 간격 설정
        decoration: BoxDecoration(
          color: isSelected ? AppColors.grey : AppColors.greyBackground, // 선택 상태에 따른 색상
          borderRadius: BorderRadius.circular(50), // 둥근 테두리 설정
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12), // 내부 패딩 설정
          child: Center(
            child: Text(
              keyword, // 키워드 텍스트
              maxLines: 1, // 한 줄로 제한
              overflow: TextOverflow.ellipsis, // 길어질 경우 생략
              style: TextStyle(
                color: isSelected ? Colors.white : AppColors.black, // 선택 여부에 따른 텍스트 색상
                fontSize: 12, // 텍스트 크기
                fontFamily: GoogleFonts.nanumGothic().fontFamily, // 폰트 설정
                fontWeight: FontWeight.w500, // 텍스트 굵기 설정
              ),
            ),
          ),
        ),
      ),
    );
  }
}