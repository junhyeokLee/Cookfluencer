import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/ui/widget/common/LikeChannelButton.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';

class ChannelItemHorizontal extends StatelessWidget {
  final ChannelData channelData;

  const ChannelItemHorizontal({
    Key? key,
    required this.channelData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 0, top: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // 콘텐츠가 왼쪽 정렬되도록 유지
        crossAxisAlignment: CrossAxisAlignment.center, // 콘텐츠가 중앙 정렬되도록 유지
        children: [
          // 썸네일 이미지
          Hero(
            tag: 'channelHero_${channelData.id}', // 채널 ID를 태그로 사용
            child: ClipOval(
              child: Image.network(
                channelData.thumbnailUrl,
                width: ScreenUtil.width(context, 0.25), // 썸네일 이미지 크기
                height: ScreenUtil.width(context, 0.25), // 썸네일 이미지 크기
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // 에러 발생 시 표시할 아이콘
              ),
            ),
          ),
          const SizedBox(width: 12), // 간격
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // 컬럼 내 모든 요소를 왼쪽 정렬
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // 좌우 정렬
                  crossAxisAlignment: CrossAxisAlignment.center, // 요소들이 수평으로 중앙 정렬되도록 유지
                  children: [
                    // Flexible로 텍스트의 크기를 조정
                    Flexible(
                      child: Row(
                        children: [
                          Image.asset(Assets.youtube, width: 20, height: 20),
                          const SizedBox(width: 2), // 간격
                          Flexible(
                            child: Text(
                              channelData.channelName,
                              maxLines: 1, // 한 줄로 제한
                              overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                              style: Theme.of(context).textTheme.labelMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8), // 텍스트와 좋아요 버튼 사이 간격
                    LikeChannelButton(channelData: channelData,rightMargin: 16,), // 좋아요 버튼을 오른쪽에 배치
                  ],
                ),
                const SizedBox(height: 4), // 간격
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center, // 각 아이콘과 텍스트가 수평으로 정렬되도록 유지
                  children: [
                    Image.asset(Assets.group, width: 20, height: 20, color: AppColors.grey), // group 아이콘
                    const SizedBox(width: 5), // 간격
                    Text(
                      channelData.subscriberCount.toSubscribeUnit(), // 구독자 수를 포맷팅
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.grey, fontSize: 12),
                    ),
                    const SizedBox(width: 4), // 간격
                    CircleAvatar(radius: 1, backgroundColor: AppColors.grey),
                    const SizedBox(width: 4), // 간격
                    Text(
                      '동영상 ${channelData.videoCount}개', // 동영상 수
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: AppColors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
