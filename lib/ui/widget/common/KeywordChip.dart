import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';

class KeywordChip extends StatelessWidget {
  const KeywordChip({
    Key? key,
    required this.keyword, // 키워드 텍스트
    required this.image, // 이미지 URL
    required this.isSelected, // 선택 여부
    required this.onTap, // 선택 시 호출될 함수
  }) : super(key: key);

  final String keyword; // 키워드 이름
  final String image; // 이미지 URL
  final bool isSelected; // 선택 상태
  final VoidCallback onTap; // 선택 시 동작

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(); // 기존의 onTap 동작 실행
        context.goNamed(
          AppRoute.homeKeyword.name,
          pathParameters: {'keyword': keyword},
        );
      },
      child: Container(
        width: ScreenUtil.width(context, 0.6),
        height: ScreenUtil.height(context, 0.6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.grey.withOpacity(0.7) : AppColors.greyBackground.withOpacity(0.7), // 선택 상태에 따른 색상
          borderRadius: BorderRadius.circular(16), // 둥근 테두리 설정
          image: DecorationImage(
            image: CachedNetworkImageProvider(image), // 네트워크에서 이미지를 불러옴
            fit: BoxFit.cover, // 이미지를 전체에 맞게 채움
          ),
        ),
      ),
    );
  }
}
