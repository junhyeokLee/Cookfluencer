// lib/ui/widget/common/ErrorMessage.dart

import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  final String message;  // 오류 메시지를 받을 필드

  const ErrorMessage({
    Key? key,
    required this.message, // 필수 인자
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(42),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.red, // 오류 메시지 색상
          ),
          textAlign: TextAlign.center, // 중앙 정렬
        ),
      ),
    );
  }
}