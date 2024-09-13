import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/CustomChannelImage.dart';
import 'package:cookfluencer/ui/widget/common/CustomVideoImage.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecommendChannelVideos extends HookConsumerWidget {
  final String channelId;

  const RecommendChannelVideos({
    Key? key,
    required this.channelId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 해당 채널의 비디오를 가져오는 provider 호출
    final videoListAsyncValue = ref.watch(channelVideosProvider(channelId));

    return videoListAsyncValue.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const Text('이 채널에는 비디오가 없습니다.');
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index].data() as Map<String, dynamic>;
            int viewCount = int.tryParse(video['view_count'].toString()) ?? 0;

            return VideoItem(
              video: video, // 비디오 데이터
              channelName: video['channel_name'], // 채널 이름
              viewCount: viewCount, // 조회수
              size: ScreenUtil.width(context, 0.25), // 썸네일 사이즈
              titleWidth: ScreenUtil.width(context, 0.45), // 제목 너비
              channelWidth: ScreenUtil.width(context, 0.14), // 채널 이름 너비
            );
          },
        );
      },
      loading: () => CircularLoading(),
      error: (error, stackTrace) => ErrorMessage(message: '${error}'),
    );
  }
}
