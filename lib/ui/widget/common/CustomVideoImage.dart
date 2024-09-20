import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomVideoImage extends StatelessWidget {
  final String imageUrl;
  final double size; // 이미지 크기
  final BoxFit fit; // 이미지 맞춤 방식
  final Image? icon; // 오버레이 아이콘

  const CustomVideoImage({
    super.key,
    required this.imageUrl,
    required this.size,
    this.fit = BoxFit.cover, // 기본 값은 BoxFit.cover
    this.icon, // 아이콘을 선택적으로 받음
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: imageUrl,
          imageBuilder: (context, imageProvider) => Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // 모서리를 둥글게
              image: DecorationImage(
                image: imageProvider,
                fit: fit,
              ),
            ),
          ),
          placeholder: (context, url) => Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // 모서리를 둥글게
              color: AppColors.greyBackground, // 로딩 중 배경색
            ),
            child: const Center(
              child: CircularProgressIndicator(
                color: AppColors.greyBackground,
              ), // 로딩 상태 표시
            ),
          ),
          errorWidget: (context, url, error) => Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8), // 모서리를 둥글게
              color: AppColors.greyBackground,
            ),
            child: const Icon(Icons.error, color: Colors.red), // 에러 상태 표시
          ),
        ),
        // 오른쪽 아래에 아이콘을 배치
        if (icon != null) // 아이콘이 있으면 보여줌
          Positioned(
            bottom: 8, // 아래에서 8px 떨어진 위치
            right: 8,  // 오른쪽에서 8px 떨어진 위치
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black54, // 배경을 반투명 검정색으로
                shape: BoxShape.circle, // 아이콘을 원형으로 감싸기
              ),
              child: icon
            ),
          ),
      ],
    );
  }
}
