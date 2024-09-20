import 'package:flutter/material.dart';

class BarIndicator extends StatelessWidget {
  final int currentIndex; // 현재 페이지 인덱스
  final int itemCount; // 전체 아이템 수
  final Color activeColor; // 활성화된 인디케이터 색상
  final Color inactiveColor; // 비활성화된 인디케이터 색상
  final double barHeight; // 프로그레스 바의 높이
  final double barWidth; // 프로그레스 바의 너비

  const BarIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
    this.activeColor = Colors.black, // 기본 활성화 색상
    this.inactiveColor = Colors.grey, // 기본 비활성화 색상
    this.barHeight = 8.0, // 기본 프로그레스 바의 높이
    this.barWidth = 200.0, // 기본 프로그레스 바의 너비
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18, bottom: 18),
      child: Center(
        child: Container(
          width: barWidth, // 프로그레스 바의 전체 너비
          height: barHeight, // 프로그레스 바의 높이
          decoration: BoxDecoration(
            color: inactiveColor, // 비활성화된 색상
            borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
          ),
          child: Stack(
            children: [
              // 활성화된 진행률 바
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: (currentIndex + 1) / itemCount * barWidth, // 현재 인덱스에 따라 너비 설정
                  height: barHeight, // 프로그레스 바의 높이
                  decoration: BoxDecoration(
                    color: activeColor, // 활성화된 색상
                    borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
