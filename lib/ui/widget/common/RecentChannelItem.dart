import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/screen/VideoDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/ui/widget/common/CustomVideoImage.dart';
import 'package:cookfluencer/ui/widget/common/LikeVideoButton.dart'; // LikeVideoButton 추가
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/util/DateUtil.dart';
import '../../../data/channelData.dart';
import 'CustomPageRouter.dart';

class RecentChannelItem extends StatelessWidget {
  final ChannelData channel; // 비디오 데이터
  final double size; // 썸네일 사이즈
  final double titleWidth; // 비디오 제목 너비
  final double channelWidth; // 채널 이름 너비
  final VoidCallback onChannelItemClick;
  final bool showLikeButton; // 비디오 클릭 시 호출할 콜백 추가
  final bool showChannelName; // 채널 이름 표시 여부
  final bool paddiongNone;

  const RecentChannelItem({
    Key? key,
    required this.channel,
    required this.size, // 썸네일 사이즈 추가
    required this.titleWidth, // 제목 너비 추가
    required this.channelWidth, // 채널 이름 너비 추가
    required this.onChannelItemClick, // 콜백 전달
    this.showLikeButton = false,
    this.showChannelName = true, // 채널 이름 표시 여부 기본값 추가
    this.paddiongNone = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 에러 상태 확인 (예: 썸네일 URL이 없거나 비디오 제목이 비어있으면 에러로 판단)
    bool hasError = channel.thumbnailUrl.isEmpty || channel.channelName.isEmpty;

    return InkWell(
      // 에러가 있으면 클릭 이벤트를 null로 설정해 클릭 불가 상태로 만듦
      onTap: hasError
          ? null // 에러가 있을 경우 클릭 불가
          : () {
        // 정상적인 비디오 클릭 처리
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => ChannelDetailScreen(channelData: channel),
          ),
        );
      },
      child: Container(
        margin: paddiongNone ? EdgeInsets.zero : EdgeInsets.only(bottom: 16),
        padding: paddiongNone ? EdgeInsets.symmetric(horizontal: 0, vertical: 0) : EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        decoration: BoxDecoration(
          color: hasError ? Colors.red.withOpacity(0.1) : Colors.transparent, // 에러 시 배경색 처리
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: size, // 전달받은 사이즈 사용
              height: size, // 1:1 비율 유지
              child: ClipRRect(
                borderRadius: BorderRadius.circular(50), // 라운드 처리
                child: Hero(
                  // tag: 'video_${video.id}',
                  tag: '',
                  child: CustomVideoImage(
                    imageUrl: channel.thumbnailUrl, // 썸네일 이미지
                    size: size,
                    fit: BoxFit.cover,
                    iconBottomPadding: 4.0,
                    iconRightPadding: 4.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 타이틀과 버튼 사이에 공간 배분
                    children: [
                      Container(
                        width: titleWidth, // 전달받은 제목 너비 사용
                        child: Text(
                          channel.channelName, // 비디오 제목
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4), // 간격
                  Row(
                    children: [
                      Image.asset(Assets.group, width: 16.w, height: 16.h),
                      const SizedBox(width: 5),
                      Text(
                          channel.subscriberCount.toSubscribeUnit(), // 구독자 수 포맷
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.grey,
                            fontSize: 11.sp,
                          )
                      ),
                      const SizedBox(width: 4),
                      CircleAvatar(radius: 1, backgroundColor: AppColors.grey),
                      const SizedBox(width: 4),
                      Text(
                          '동영상 ${channel.videoCount}개', // 동영상 수
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.grey,
                            fontSize: 11.sp,
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 4), // 간격
                  Text(
                    channel.channelDescription,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.grey,
                      fontSize: 11.sp,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}