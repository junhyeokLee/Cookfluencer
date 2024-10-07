import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/LikeChannelButton.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChannelItems extends HookConsumerWidget {
  final ChannelData channelData;
  final VoidCallback onChannelItemClick; // 채널 클릭 시 호출할 콜백 추가

  const ChannelItems({
    Key? key,
    required this.channelData,
    required this.onChannelItemClick, // 콜백 전달
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 비디오 목록을 가져오는 프로바이더
    final videoListAsyncValue = ref.watch(channelVideosProvider(channelData.id));

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 채널 썸네일
            InkWell(
              onTap: () {
                onChannelItemClick(); // 채널 클릭 시 콜백 호출
              },
              child: ClipOval(
                child: Image.network(
                  channelData.thumbnailUrl,
                  width: 0.4.sw,
                  height: 0.4.sw,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
            // 좋아요 버튼
            LikeChannelButton(channelData: channelData, rightMargin: 20)

          ],
        ),
        SizedBox(height: 8,),
        Row(
          children: [
            Image.asset(Assets.youtube, width: 24.w, height: 24.h),
            const SizedBox(width: 5),
            Flexible(
              child: Container(
                width: 0.65.sw,
                child: Text(
                  channelData.channelName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Image.asset(Assets.group, width: 16.w, height: 16.h),
            const SizedBox(width: 5),
            Text(
              channelData.subscriberCount.toSubscribeUnit(), // 구독자 수 포맷
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
              '동영상 ${channelData.videoCount}개', // 동영상 수
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.grey,
                  fontSize: 11.sp,
                )
            ),
          ],
        ),
        const SizedBox(height: 24), // 간격
        videoListAsyncValue.when(
          data: (videos) {
            if (videos.isEmpty) {
              return const Text('이 채널에는 비디오가 없습니다.');
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index] as Map<String, dynamic>;
                // 비디오 데이터 매핑
                final videoData = VideoData(
                  id: video['id'] ?? 'Unknown',
                  channelId: video['channel_id'] ?? 'Unknown',
                  channelName: video['channel_name'] ?? 'Unknown',
                  description: video['description'] ?? '',
                  thumbnailUrl: video['thumbnail_url'] ?? '',
                  title: video['title'] ?? 'Unknown',
                  uploadDate: video['upload_date'] ?? '',
                  videoId: video['video_id'] ?? '',
                  videoUrl: video['video_url'] ?? '',
                  viewCount: int.tryParse(video['view_count'].toString()) ?? 0,
                  section: video['section'] ?? '',
                );

                return VideoItem(
                  video: videoData,
                  size: 0.25.sw, // 썸네일 사이즈
                  titleWidth: 0.45.sw, // 제목 너비
                  channelWidth: 0.14.sw,
                  onVideoItemClick: () {  }, // 채널 이름 너비
                );
              },
            );
          },
          loading: () => const CircularLoading(),
          error: (error, stackTrace) => ErrorMessage(message: '$error'),
        ),
      ],
    );
  }
}
