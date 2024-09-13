import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';

class ChannelItemHorizontal extends StatelessWidget {
  final String channelName; // 채널 이름
  final String imageUrl; // 채널 썸네일 URL
  final int subscriberCount; // 구독자 수
  final int videoCount; // 동영상 수

  const ChannelItemHorizontal({
    Key? key,
    required this.channelName,
    required this.imageUrl,
    required this.subscriberCount,
    required this.videoCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipOval(
          child: Image.network(
            imageUrl,
            width: ScreenUtil.width(context, 0.25), // 썸네일 이미지 크기
            height: ScreenUtil.width(context, 0.25), // 썸네일 이미지 크기
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // 에러 발생 시 표시할 아이콘
          ),
        ),
        const SizedBox(width: 12), // 간격
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트 왼쪽 정렬
            children: [
              Row(
                children: [
                  Image.asset(Assets.youtube, width: 18, height: 18, color: AppColors.black),
                  const SizedBox(width: 5), // 간격
                  Flexible(
                    child: Text(
                      channelName,
                      maxLines: 1, // 한 줄로 제한
                      overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6), // 간격
              Row(
                children: [
                  Image.asset(Assets.group, width: 14, height: 14, color: AppColors.grey), // group 아이콘
                  const SizedBox(width: 5), // 간격
                  Text(
                    subscriberCount.toSubscribeUnit(), // 구독자 수를 포맷팅
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                  const SizedBox(width: 4), // 간격
                  CircleAvatar(radius: 1, backgroundColor: AppColors.grey),
                  const SizedBox(width: 4), // 간격
                  Text(
                    '동영상 ${videoCount}개', // 동영상 수
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: AppColors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_ios_rounded, color: AppColors.black, size: 12), // 화살표 아이콘
      ],
    );
  }
}