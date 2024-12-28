import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int currentIndex; // 현재 페이지 인덱스
  final int itemCount; // 전체 아이템 수
  final Color activeColor; // 활성화된 인디케이터 색상
  final Color inactiveColor; // 비활성화된 인디케이터 색상
  final double dotSize; // 인디케이터 크기
  final double spacing; // 인디케이터 간 간격

  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.activeColor = Colors.black, // 기본 활성화 색상
    this.inactiveColor = Colors.grey, // 기본 비활성화 색상
    this.dotSize = 8.0, // 기본 인디케이터 크기
    this.spacing = 4.0, // 기본 간격
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18,bottom: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
          return Container(
            width: dotSize, // 인디케이터의 너비
            height: dotSize, // 인디케이터의 높이
            margin: EdgeInsets.symmetric(horizontal: spacing), // 인디케이터 간격
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentIndex == index ? activeColor : inactiveColor, // 색상 변경
            ),
          );
        }),
      ),
    );
  }
}