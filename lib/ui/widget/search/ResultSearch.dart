import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/CustomRoundButton.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultSearch extends HookConsumerWidget {
  final String searchQuery;

  const ResultSearch({
    super.key,
    required this.searchQuery,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount);
    final showFilterOptions = useState<bool>(false);
    final isAllInfluencersView = useState<bool>(false);

    final searchChannelListAsyncValue = ref.watch(searchChannelProvider(searchQuery));
    final searchParams = useState<Map<String, dynamic>>({
      'query': searchQuery,
      'filter': selectedFilter.value,
    });

    useEffect(() {
      searchParams.value = {
        'query': searchQuery,
        'filter': selectedFilter.value,
      };
      return null;
    }, [selectedFilter.value]);

    final searchVideoListAsyncValue = ref.watch(searchFilterVideoProvider(searchParams.value));

    return WillPopScope(
      onWillPop: () async {
        if (isAllInfluencersView.value) {
          isAllInfluencersView.value = false; // 전체 보기 상태를 종료
          return false; // 현재 페이지 유지
        }
        return true; // 페이지를 닫도록 허용
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 현재 인플루언서 전체 보기 상태가 아닐 때 보여줄 내용
            if (!isAllInfluencersView.value) ...[
              searchChannelListAsyncValue.when(
                data: (channels) {
                  if (channels.isEmpty) {
                    return Center(
                      child: EmptyMessage(message: '검색된 쿡플루언서가 없습니다.'),
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 24),
                        child: Text('인플루언서', style: Theme.of(context).textTheme.labelLarge),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        height: ScreenUtil.height(context, 0.25),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: channels.length,
                          itemBuilder: (context, index) {
                            final channel = channels[index].data() as Map<String, dynamic>;
                            final channelData = ChannelData(
                              id: channel['id'] ?? 'Unknown',
                              channelName: channel['channel_name'] ?? 'Unknown',
                              channelDescription: channel['channel_description'] ?? '',
                              channelUrl: channel['channel_url'] ?? '',
                              thumbnailUrl: channel['thumbnail_url'] ?? '',
                              subscriberCount: int.tryParse(channel['subscriber_count'].toString()) ?? 0,
                              videoCount: channel['video_count'] ?? 0,
                              videos: channel['videos'] ?? [],
                              section: channel['section'] ?? '',
                            );

                            final paddingLeft = index == 0 ? 24.0 : 0.0;
                            final paddingRight = 12.0;

                            return Padding(
                              padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
                              child: ChannelItem(
                                channelData: channelData,
                                size: ScreenUtil.width(context, 0.35),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
                        child: CustomRoundButton(
                          isEnabled: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.black,
                          bgColor: AppColors.primaryColor,
                          leftIcon: Icon(
                            Icons.search,
                            size: 16,
                            color: AppColors.grey,
                          ),
                          text: '인플루언서 전체 보기',
                          onTap: () {
                            isAllInfluencersView.value = true; // 상태 변경
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => CircularLoading(),
                error: (error, stackTrace) => ErrorMessage(message: '${error}'),
              ),

              // 비디오 검색 결과 처리
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
                child: Text('레시피 영상', style: Theme.of(context).textTheme.labelLarge),
              ),

              Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16, right: 16),
                  child: FilterRecipe(
                    selectedFilter: selectedFilter,
                    showFilterOptions: showFilterOptions,
                  ),
                ),
              ),

              searchVideoListAsyncValue.when(
                data: (videos) {
                  if (videos.isEmpty) {
                    return EmptyMessage(message: '아직 레시피가 준비되지 않았어요. \n\n 다른 키워드로 검색해보세요.');
                  }
                  return Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: videos.length,
                      itemBuilder: (context, index) {
                        final video = videos[index].data() as Map<String, dynamic>;
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
                        return Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: VideoItem(
                            video: videoData,
                            size: ScreenUtil.width(context, 0.25),
                            titleWidth: ScreenUtil.width(context, 0.6),
                            channelWidth: ScreenUtil.width(context, 0.3),
                          ),
                        );
                      },
                    ),
                  );
                },
                loading: () => CircularLoading(),
                error: (error, stackTrace) => ErrorMessage(message: '${error}'),
              ),
            ],

            // 인플루언서 전체 보기로 변경된 경우 보여줄 새로운 위젯
            if (isAllInfluencersView.value) ...[
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 24),
                child: Text('전체 인플루언서 목록', style: Theme.of(context).textTheme.labelLarge),
              ),
              // 전체 인플루언서 목록을 표시하는 위젯을 추가하세요.
              // 예시: ListView 또는 GridView를 사용하여 전체 인플루언서 정보를 나열
            ],
          ],
        ),
      ),
    );
  }
}