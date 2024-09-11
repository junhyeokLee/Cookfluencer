import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecommendKeywordVideos extends HookConsumerWidget {
  final String keywrod;

  const RecommendKeywordVideos({
    Key? key,
    required this.keywrod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 해당 채널의 비디오를 가져오는 provider 호출
    final keywrodVideoListAsyncValue = ref.watch(searchKeywordVideoProvider(keywrod));

    return keywrodVideoListAsyncValue.when(
      data: (videos) {
        if (videos.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 48,bottom: 56),
            child: Center(child: const Text('이 키워드에는 비디오가 없습니다.')),
          );
        }

        // 비디오 리스트가 있을 경우 최대 3개의 비디오를 세로로 표시
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: videos.length,
          itemBuilder: (context, index) {
            final video = videos[index].data() as Map<String, dynamic>;
            int viewCount = int.tryParse(video['view_count'].toString()) ?? 0; // 숫자로 변환

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Container(
                    width: ScreenUtil.width(context, 0.25),
                    // 화면 너비의 60%로 설정
                    height: ScreenUtil.width(context, 0.25),
                    // 1:1 비율로 높이 설정
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      // 라운드 처리
                      child: CachedNetworkImage(
                        imageUrl: video['thumbnail_url'],
                        // 비디오 썸네일 표시
                        fit: BoxFit.cover,
                        // 또는 none
                        placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.greyBackground),
                            )),
                        // 로딩 중 인디케이터
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error), // 에러 발생 시 아이콘 표시
                      ),
                    ),
                  ),
                  const SizedBox(width: 12), // 간격을 줄임
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // 간격
                            Container(
                              width: ScreenUtil.width(context, 0.55),
                              child: Text(
                                video['title'], // 채널이름
                                maxLines: 1,
                                // 한 줄로 제한
                                overflow: TextOverflow.ellipsis,
                                // 길어질 경우 생략
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6), // 간격
                        Row(
                          children: [

                            Image.asset(Assets.view,width: 14,height: 14,color: AppColors.grey), // 별 아이콘
                            SizedBox(width: 4), // 간격
                            Text(
                              viewCount.toViewCountUnit(), // 조회수를 한국어 형식으로 변환
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),

                            SizedBox(width: 16),

                            Image.asset(Assets.youtube,
                                width: 14,
                                height: 14,
                                color: AppColors.grey),
                            // youtube 아이콘
                            SizedBox(width: 4),
                            // 간격
                            Container(
                              width: ScreenUtil.width(context, 0.3),
                              child: Text(
                                video['channel_name'], // 채널이름
                                maxLines: 1,
                                // 한 줄로 제한
                                overflow: TextOverflow.ellipsis,
                                // 길어질 경우 생략
                                style: TextStyle(
                                  color: AppColors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        )
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