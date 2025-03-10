import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Customchannelimage extends StatelessWidget {
  final String imageUrl;
  final double size; // 이미지 크기
  final BoxFit fit; // 이미지 맞춤 방식

  const Customchannelimage({
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
          borderRadius: BorderRadius.circular(100), // 원형으로 만들기
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
          borderRadius: BorderRadius.circular(100), // 원형으로 만들기
          color: AppColors.greyBackground, // 로딩 중 배경색
        ),
        child:  Center(
          child: Icon(
            Icons.person,
            size: 0.2.sw,
            color: AppColors.grey, // 로딩 중 아이콘 컬러
          ), // 로딩 상태 표시
        ),
      ),
      errorWidget: (context, url, error) => Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100), // 원형으로 만들기
          color: AppColors.greyBackground,
        ),
        child:  Icon(
          Icons.person, // 에러 시 기본 사용자 아이콘
          size: 0.2.sw,
          color: AppColors.grey, // 에러 상태 표시 컬러
        ),
      ),
    );
  }
}