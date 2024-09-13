// lib/ui/widget/common/ErrorMessage.dart

import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:flutter/material.dart';

class EmptyMessage extends StatelessWidget {
  final String message;  // 오류 메시지를 받을 필드

  const EmptyMessage({
    Key? key,
    required this.message, // 필수 인자
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(42),
        child: Center(
          child: Column(
            children: [
              Image.asset(
                Assets.view,
                color: AppColors.grey, // 이미지 색상
                width: 42,
                height: 42,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 24),
                child: Text(
                  '${message}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.grey, // 오류 메시지 색상
                  ),
                  textAlign: TextAlign.center, // 중앙 정렬
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}