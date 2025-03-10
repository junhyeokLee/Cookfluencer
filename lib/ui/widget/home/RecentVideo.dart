import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/ui/screen/VideoDetailScreen.dart';
import 'package:cookfluencer/ui/widget/common/CustomVideoImage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/util/DateUtil.dart';
import '../../screen/RecentVideoScreen.dart';
import '../common/VideoItem.dart';

class RecentVideo extends HookConsumerWidget {
  const RecentVideo({
    super.key,
    required this.recentVideoListAsyncValue,
  });

  final List<VideoData> recentVideoListAsyncValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16,top: 0, bottom: 12),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => RecentVideoScreen(),
                ),
              );
            },
            splashColor: Colors.transparent,  // 리플 효과 제거
            highlightColor: Colors.transparent, // 클릭 시 색상 제거
            hoverColor: Colors.transparent,  // 마우스 오버 효과 제거 (웹 대응)
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text('새로운 레시피', style: Theme.of(context).textTheme.titleLarge),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_forward_ios,size: 20,),
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => RecentVideoScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 200.w, // 2행의 높이 + 간격
          child: GridView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2행 구성
              // mainAxisSpacing: 18, // 세로 간격
              childAspectRatio: 0.32, // 아이템 비율 조정
            ),
            itemCount: recentVideoListAsyncValue.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context, index) {
              var video = recentVideoListAsyncValue[index];
              int viewCount = int.tryParse(video.viewCount.toString()) ?? 0;
              return InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => VideoDetailScreen(videoData: video),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    VideoItem(
                      video: video,
                      size: 0.25.sw, // 썸네일 사이즈
                      titleWidth: 0.45.sw, // 제목 너비
                      channelWidth: 0.14.sw,
                      onVideoItemClick: () {  }, // 채널 이름 너비
                      showChannelName: true,
                      paddiongNone: true,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}