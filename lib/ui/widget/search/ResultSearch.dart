import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/CustomRoundButton.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResultSearch extends HookConsumerWidget {
  final String searchQuery;
  final Function(ChannelData) onChannelItemClick; // 콜백 추가
  final Function(String) onTotalChannelClick; // 콜백 추가

  const ResultSearch({
    super.key,
    required this.searchQuery,
    required this.onChannelItemClick, // 콜백 받기
    required this.onTotalChannelClick, // 콜백 받기
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount);
    final showFilterOptions = useState<bool>(false);
    final pagingController = useState(
      PagingController<int, QueryDocumentSnapshot>(firstPageKey: 0),
    );

    final searchChannelListAsyncValue =
        ref.watch(searchChannelProvider(searchQuery));
    final searchParams = useState<Map<String, dynamic>>({
      'query': searchQuery,
      'filter': selectedFilter.value,
    });

    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final searchParams = {
          'query': searchQuery,
          'filter': selectedFilter.value,
          'start_after':
              pageKey == 0 ? null : pagingController.value.itemList!.last,
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos =
            await ref.read(searchFilterVideoProvider(searchParams).future);

        final isLastPage = newVideos.isEmpty;
        if (isLastPage) {
          pagingController.value.appendLastPage(newVideos);
        } else {
          final nextPageKey = pageKey + newVideos.length;
          pagingController.value.appendPage(newVideos, nextPageKey);
        }
      } catch (error) {
        pagingController.value.error = error; // 오류 발생 시 처리
      }
    }

    // 필터 변경 시, PagingController를 새로 생성
    useEffect(() {
      // PagingController 초기화
      pagingController.value = PagingController<int, QueryDocumentSnapshot>(
        firstPageKey: 0,
      );
      // 필터가 변경되면 새로운 페이지 요청
      fetchVideos(0); // 이제 이 호출이 올바르게 작동합니다.
      return null; // clean up 함수 반환
    }, [selectedFilter.value]);

    useEffect(() {
      // PagingController에 페이지 요청 리스너 추가
      pagingController.value.addPageRequestListener(fetchVideos);
      return () =>
          pagingController.value.removePageRequestListener(fetchVideos);
    }, [pagingController.value]);

    // useEffect(() {
    //   searchParams.value = {
    //     'query': searchQuery,
    //     'filter': selectedFilter.value,
    //   };
    //   return null;
    // }, [selectedFilter.value]);
    //
    // final searchVideoListAsyncValue =
    // ref.watch(searchFilterVideoProvider(searchParams.value));

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: channels.length,
                          itemBuilder: (context, index) {
                            final channel =
                                channels[index].data() as Map<String, dynamic>;
                            final channelData = ChannelData(
                              id: channel['id'] ?? 'Unknown',
                              channelName: channel['channel_name'] ?? 'Unknown',
                              channelDescription:
                                  channel['channel_description'] ?? '',
                              channelUrl: channel['channel_url'] ?? '',
                              thumbnailUrl: channel['thumbnail_url'] ?? '',
                              subscriberCount: int.tryParse(
                                      channel['subscriber_count'].toString()) ??
                                  0,
                              videoCount: channel['video_count'] ?? 0,
                              videos: channel['videos'] ?? [],
                              section: channel['section'] ?? '',
                            );

                            final paddingLeft = index == 0 ? 24.0 : 0.0;
                            final paddingRight = 12.0;

                            return Padding(
                              padding: EdgeInsets.only(
                                  left: paddingLeft, right: paddingRight),
                              child: ChannelItem(
                                key: ValueKey(channelData.id),
                                // GlobalKey 대신 ValueKey 사용
                                channelData: channelData,
                                size: ScreenUtil.width(context, 0.35),
                                onChannelItemClick: () {
                                  onChannelItemClick(channelData); // 콜백 호출
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 24, top: 12, right: 24, bottom: 12),
                        child: CustomRoundButton(
                          isEnabled: true,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          textColor: AppColors.black,
                          bgColor: AppColors.keywordBackground,
                          leftIcon: Icon(
                            Icons.search,
                            size: 16,
                            color: AppColors.grey,
                          ),
                          text: '인플루언서 전체 보기',
                          onTap: () {
                            onTotalChannelClick(searchQuery); // 콜백 호출
                            // context.goNamed(
                            //   AppRoute.channels.name,
                            //   pathParameters: {'channels': searchQuery},
                            // );
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
                child: Text('레시피 영상',
                    style: Theme.of(context).textTheme.labelLarge),
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
            ],
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 16),
          sliver: PagedSliverList<int, QueryDocumentSnapshot>(
            pagingController: pagingController.value,
            builderDelegate: PagedChildBuilderDelegate<QueryDocumentSnapshot>(
              itemBuilder: (context, videoSnapshot, index) {
                final video = videoSnapshot.data() as Map<String, dynamic>;
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
                  key: ValueKey(videoData.id),
                  // 고유한 ID를 사용해 ValueKey 설정
                  video: videoData,
                  size: ScreenUtil.width(context, 0.2),
                  titleWidth: ScreenUtil.width(context, 0.65),
                  channelWidth: ScreenUtil.width(context, 0.35),
                );
              },
              firstPageProgressIndicatorBuilder: (context) =>
                  Center(child: CircularLoading()),
              newPageProgressIndicatorBuilder: (context) =>
                  Center(child: CircularLoading()),
              noItemsFoundIndicatorBuilder: (context) =>
                  EmptyMessage(message: '비디오가 없음'),
              noMoreItemsIndicatorBuilder: (context) =>
                  EmptyMessage(message: '더 이상 비디오 없음'),
            ),
          ),
        ),
        // 오류 발생 시 메시지 표시
        if (pagingController.value.error != null)
          SliverToBoxAdapter(
            child:
                ErrorMessage(message: '오류 발생: ${pagingController.value.error}'),
          ),
      ],
    );
  }
}
