import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';

class CircularLoading extends StatelessWidget {
  const CircularLoading({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(42),
      child: Center(
        child: CircularProgressIndicator(color: AppColors.greyBackground),
      ),
    );
  }
}