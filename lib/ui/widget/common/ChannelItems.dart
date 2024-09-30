import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/LikeChannelButton.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';

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
                  width: ScreenUtil.width(context, 0.4),
                  height: ScreenUtil.width(context, 0.4),
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
            ),
            // 좋아요 버튼
            LikeChannelButton(channelData: channelData, rightMargin: 20)

          ],
        ),
        Row(
          children: [
            Image.asset(Assets.youtube, width: 20, height: 20),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                channelData.channelName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6), // 간격
        Row(
          children: [
            Image.asset(Assets.group, width: 14, height: 14, color: AppColors.grey),
            const SizedBox(width: 5),
            Text(
              channelData.subscriberCount.toSubscribeUnit(), // 구독자 수 포맷
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.grey, fontSize: 12),
            ),
            const SizedBox(width: 4),
            CircleAvatar(radius: 1, backgroundColor: AppColors.grey),
            const SizedBox(width: 4),
            Text(
              '동영상 ${channelData.videoCount}개', // 동영상 수
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: AppColors.grey, fontSize: 12),
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
                final video = videos[index].data() as Map<String, dynamic>;
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
                  size: ScreenUtil.width(context, 0.25), // 썸네일 사이즈
                  titleWidth: ScreenUtil.width(context, 0.45), // 제목 너비
                  channelWidth: ScreenUtil.width(context, 0.14), // 채널 이름 너비
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
