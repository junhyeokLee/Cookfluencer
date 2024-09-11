import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
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

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: ScreenUtil.width(context, 0.25),
                    height: ScreenUtil.width(context, 0.25), // 1:1 비율 유지
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8), // 라운드 처리
                      child: CachedNetworkImage(
                        imageUrl: video['thumbnail_url'],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.greyBackground),
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // 간격
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: ScreenUtil.width(context, 0.45),
                              child: Text(
                                video['title'], // 채널 제목
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6), // 간격
                        Row(
                          children: [
                            Image.asset(Assets.view, width: 14, height: 14, color: AppColors.grey), // 조회수 아이콘
                            SizedBox(width: 4), // 간격
                            Text(
                              viewCount.toViewCountUnit(), // 조회수 표시
                              style: TextStyle(color: AppColors.grey, fontSize: 12),
                            ),
                            SizedBox(width: 16),
                            Image.asset(Assets.youtube, width: 14, height: 14, color: AppColors.grey), // 유튜브 아이콘
                            SizedBox(width: 4), // 간격
                            Container(
                              width: ScreenUtil.width(context, 0.14),
                              child: Text(
                                video['channel_name'], // 채널 이름
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(color: AppColors.grey, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppColors.greyBackground),
      ),
      error: (error, stack) => Text('비디오 로드 중 오류 발생: $error'),
    );
  }
}