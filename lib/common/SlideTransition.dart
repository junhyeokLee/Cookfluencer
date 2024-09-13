import 'package:flutter/material.dart';

// SlideTransition 애니메이션을 정의
SlideTransition SlideAnimation(
    Animation<double> animation,
    Widget child,
    ) {
  const begin = Offset(1.0, 0.0);
  const end = Offset.zero;
  const curve = Curves.easeInOut;

  // Tween을 사용해 애니메이션의 시작과 끝을 정의
  final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  final offsetAnimation = animation.drive(tween);

  // 애니메이션의 지속 시간 설정
  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}