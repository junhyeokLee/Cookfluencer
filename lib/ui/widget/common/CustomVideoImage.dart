import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomVideoImage extends StatelessWidget {
  final String imageUrl;
  final double size; // 이미지 크기
  final BoxFit fit; // 이미지 맞춤 방식

  const CustomVideoImage({
    super.key,
    required this.imageUrl,
    required this.size,
    this.fit = BoxFit.cover, // 기본 값은 BoxFit.cover
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), // 원형으로 만들기
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
          borderRadius: BorderRadius.circular(8), // 원형으로 만들기
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
          borderRadius: BorderRadius.circular(8), // 원형으로 만들기
          color: AppColors.greyBackground,
        ),
        child: const Icon(Icons.error, color: Colors.red), // 에러 상태 표시
      ),
    );
  }
}