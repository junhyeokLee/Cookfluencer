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
  final String searchQuery; // 검색어를 받을 필드

  const ResultSearch({
    super.key,
    required this.searchQuery, // 검색어를 인자로 받음
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 필터링 옵션을 위한 상태 (조회순, 최신순)
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount);
    final showFilterOptions = useState<bool>(false); // 필터 옵션을 표시할지 여부

    final searchChannelListAsyncValue = ref.watch(searchChannelProvider(searchQuery));

    // 필터 옵션 변경 시만 검색 프로바이더를 호출하도록 useEffect 사용
    final searchParams = useState<Map<String, dynamic>>({
      'query': searchQuery,
      'filter': selectedFilter.value,
    });
    // 필터 옵션 변경 시 searchParams를 갱신하여 새로운 검색 요청을 보냄
    useEffect(() {
      searchParams.value = {
        'query': searchQuery,
        'filter': selectedFilter.value,
      };
      return null; // effect cleanup 없음
    }, [selectedFilter.value]);

    // 검색 결과를 비동기로 받아오는 부분
    final searchVideoListAsyncValue = ref.watch(searchFilterVideoProvider(searchParams.value));

    return SingleChildScrollView(
      // 세로 스크롤 가능하도록 감싸기
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 채널 검색 결과 처리
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
                    child: Text('인플루언서',
                        style: Theme.of(context).textTheme.labelLarge),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    height: ScreenUtil.height(context, 0.25),
                    // 가로 스크롤 리스트의 높이 설정
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // 가로 스크롤 설정
                      itemCount: channels.length,
                      itemBuilder: (context, index) {
                        final channel =
                        channels[index].data() as Map<String, dynamic>;
                        // ChannelModel에 데이터를 맵핑
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

                        // 첫 번째 아이템에만 padding-left 24 설정
                        final paddingLeft = index == 0 ? 24.0 : 0.0;
                        final paddingRight = 12.0;

                        return Padding(
                          padding: EdgeInsets.only(
                              left: paddingLeft, right: paddingRight),
                          // 오른쪽 마진 설정
                          child: ChannelItem(
                            channelData: channelData,
                            size: ScreenUtil.width(context, 0.35),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24, top: 12, right: 24, bottom: 12),
                    child: CustomRoundButton(
                      leftIcon: Icon(
                        Icons.search,
                        size: 16,
                        color: AppColors.grey,
                      ),
                      text: '인플루언서 전체 보기',
                      onTap: () {
                        context.goNamed(
                          AppRoute.channels.name,
                          pathParameters: {'searchQuery': searchQuery},
                        );
                      },
                      fontWeight: FontWeight.w700,
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
            child:
            Text('레시피 영상', style: Theme.of(context).textTheme.labelLarge),
          ),

          // 필터 위젯 사용
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
                    // ChannelModel에 데이터를 맵핑
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
          )
        ],
      ),
    );
  }
}