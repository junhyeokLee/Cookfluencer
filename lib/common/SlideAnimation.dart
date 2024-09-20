import 'package:flutter/material.dart';

class SlideAnimation extends StatelessWidget {
  final Animation<double> animation;
  final Widget child;

  const SlideAnimation(this.animation, {required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(1.0, 0.0), // 시작 위치 (오른쪽)
        end: Offset.zero, // 최종 위치 (현재 위치)
      ).animate(CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut, // 애니메이션 곡선
      )),
      child: child,
    );
  }
}