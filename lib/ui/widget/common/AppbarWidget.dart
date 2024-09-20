import 'package:cookfluencer/common/constant/assets.dart';
import 'package:flutter/material.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 48,
      title: Row(
        children: [
          // 로고 이미지 왼쪽에 공백 추가
          Padding(
            padding: const EdgeInsets.only(left: 8),  // 왼쪽에 16 픽셀 공백을 추가
            child: Image.asset(
              Assets.logo,
              height: 24,  // 이미지 크기를 조절합니다.
            ),
          ),
          SizedBox(width: 12),  // 로고와 텍스트 사이의 간격을 조절합니다.
          // 텍스트
          Text(
            'COOKFLUENCER',
            style: TextStyle(
              color: Colors.black,  // 텍스트 색상을 검은색으로 변경
              fontSize: 18,         // 폰트 크기
            ),
          ),
        ],
      ),
    );
  }

  // preferredSize 속성을 추가하여 AppBar의 크기를 지정
  @override
  Size get preferredSize => const Size.fromHeight(48);  // AppBar 높이를 48로 설정
}
