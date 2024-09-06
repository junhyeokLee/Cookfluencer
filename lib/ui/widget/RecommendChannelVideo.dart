import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelVideosList extends HookConsumerWidget {
  final String channelId;

  const ChannelVideosList({
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

        // 비디오 리스트가 있을 경우 최대 3개의 비디오를 세로로 표시
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index].data() as Map<String, dynamic>;

            return ListTile(
              leading: CachedNetworkImage(
                imageUrl: video['thumbnail_url'] ?? '',
                width: 50,
                height: 50,
                placeholder: (context, url) => const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              title: Text(video['title'] ?? '제목 없음'),
              subtitle: Text(video['description'] ?? '설명 없음'),
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => Text('비디오 로드 중 오류 발생: $error'),
    );
  }
}