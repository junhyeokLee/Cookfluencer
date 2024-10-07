import 'package:cookfluencer/common/constant/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppbarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppbarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 48.h,
      automaticallyImplyLeading: false, // 뒤로가기 버튼을 자동으로 추가하지 않음
      title: Row(
        children: [
          // 로고 이미지 왼쪽에 공백 추가
          Padding(
            padding: const EdgeInsets.only(left: 8),  // 왼쪽에 16 픽셀 공백을 추가
            child: Image.asset(
              Assets.logo,
              height: 20.h,  // 이미지 크기를 조절합니다.
            ),
          ),
          SizedBox(width: 12),  // 로고와 텍스트 사이의 간격을 조절합니다.
          // 텍스트
          Text(
            '쿡플',
            style: Theme.of(context).textTheme.titleLarge
          ),
        ],
      ),
    );
  }

  // preferredSize 속성을 추가하여 AppBar의 크기를 지정
  @override
  Size get preferredSize => const Size.fromHeight(48);  // AppBar 높이를 48로 설정
}
