import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/AlgoliaService.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch2.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchChannel.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:cookfluencer/ui/widget/search/TotalChannels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultSearchAlgoria extends HookConsumerWidget {
  final String searchQuery;
  final Function(ChannelData) onChannelItemClick;
  final Function(String) onTotalChannelClick;

  const ResultSearchAlgoria({
    super.key,
    required this.searchQuery,
    required this.onChannelItemClick,
    required this.onTotalChannelClick,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final algoliaService = AlgoliaService();
    final searchController = useTextEditingController();
    final focusNode = useFocusNode(); // FocusNode 생성
    final searchQueryState = useState<String>(searchQuery); // 상태 변수로 검색어 관리
    final searchFocus = useState<bool>(false);
    final recentSearches = useState<List<String>>([]);
    final showSearchWidgets = useState<bool>(false);
    final showFinalResults = useState<bool>(false);
    final showRecentSearch = useState<bool>(true);
    final selectedFilter = useState<FilterOption>(FilterOption.latest);
    final showFilterOptions = useState<bool>(false);
    final showChannelDetail = useState<bool>(false);
    final showTotalChannel = useState<bool>(false);
    debugPrint("알고리아 서치");

    // 키보드 닫는 기능 추가
    void _dismissKeyboard() {
      FocusScope.of(context).unfocus();
    }

    final videoPagingController = useState(
      PagingController<int, VideoData>(firstPageKey: 0),
    );
    final channelPagingController = useState(
      PagingController<int, ChannelData>(firstPageKey: 0),
    );

    final fb_searchResult = ref.watch(autoSearchChannelAndVideoProvider(searchQueryState.value));

    final initialFetch = useState<bool>(true);
    final selectedSort = useState<String>('created_at DESC'); // 기본값 최신순

// 비디오 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final videoResults = await algoliaService
            .searchTitleFilter(searchQueryState.value, pageKey, selectedSort.value)
            .first;

        // 새로 가져온 비디오 리스트
        final newVideos = videoResults.videos;

        // 기존 비디오 리스트와 중복 제거
        final existingVideos = videoPagingController.value.itemList ?? [];
        final uniqueVideos = newVideos.where(
              (newVideo) => !existingVideos.any(
                (existingVideo) => existingVideo.id == newVideo.id,
          ),
        ).toList();

        if (uniqueVideos.isEmpty) {
          videoPagingController.value.appendLastPage(uniqueVideos);
        } else {
          videoPagingController.value.appendPage(uniqueVideos, pageKey + 1);
        }
      } catch (error) {
        videoPagingController.value.error = error;
      }
    }


    // 채널 데이터 가져오기
    Future<void> fetchChannels(int pageKey) async {
      try {
        final channelResults = await algoliaService
            .searchChannel(searchQueryState.value, pageKey)
            .first;

        // 새로 가져온 채널 리스트
        final newChannels = channelResults.channels;

        // 기존 채널 리스트와 중복 제거
        final existingChannels = channelPagingController.value.itemList ?? [];
        final uniqueChannels = newChannels.where(
              (newChannel) => !existingChannels.any(
                (existingChannel) => existingChannel.id == newChannel.id,
          ),
        ).toList();

        if (uniqueChannels.isEmpty) {
          channelPagingController.value.appendLastPage(uniqueChannels);
        } else {
          channelPagingController.value.appendPage(uniqueChannels, pageKey + 1);
        }
      } catch (error) {
        channelPagingController.value.error = error;
      }
    }
    useEffect(() {
      videoPagingController.value.addPageRequestListener(fetchVideos);
      channelPagingController.value.addPageRequestListener(fetchChannels);

      fetchVideos(0);
      fetchChannels(0);

      return () {
        videoPagingController.value.removePageRequestListener(fetchVideos);
        channelPagingController.value.removePageRequestListener(fetchChannels);
      };
    }, [searchQueryState.value,selectedSort.value]);

    return GestureDetector(
      onTap: _dismissKeyboard, // 화면 터치 시 키보드 닫기
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(toolbarHeight: 0),
        body: Column(
          children: [
            SearchBarWidget(
              searchQuery: searchQueryState,
              searchController: searchController,
              recentSearches: recentSearches,
              showBackButton: true,
              enabled: true,
              showChannelDetail: false,
              focusNode: focusNode,
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  searchFocus.value = true;
                } else {
                  searchFocus.value = false;
                }
              },
              onSearchTap: () {
                searchQueryState.value = searchController.text; // 검색어 업데이트
                showSearchWidgets.value = false;
                showRecentSearch.value = false;
                showFinalResults.value = false;
                // 검색어를 초기화하는 부분 삭제
                // searchQuery.value = "";
                searchController.clear();
              },
              onSubmitted: () {
                debugPrint('검색어 서브밋?: ${searchQueryState.value}');
                _navigateToResultsPage(
                    context, searchQueryState.value); // 결과 페이지로 이동
                showSearchWidgets.value = false;
                showRecentSearch.value = true;
                showFinalResults.value = false;
                searchController.clear();

                // fetchVideos(0);
                // fetchChannels(0);
                videoPagingController.value.refresh();
                channelPagingController.value.refresh();
              },
              onBackPressed: () {
                context.pop();
              },
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return _buildSlideTransition(child, animation);
                },
                child: searchFocus.value
                    ? fb_searchResult.when(
                  data: (results) {
                    // if (results.isEmpty) {
                    //   debugPrint('파베 검색 결과 없음');
                    //   return Padding(
                    //     padding: const EdgeInsets.all(42),
                    //     child: Center(
                    //       child:
                    //       EmptyMessage(message: '쿡플루언서 검색 결과가 없습니다.'),
                    //     ),
                    //   );
                    // }
                    return AutoSearch2(
                      key: ValueKey('autoSearch'),
                      // results: results,
                      searchQuery: searchQueryState,
                      // searchController: searchController,
                      onSubmitted: () {
                        showSearchWidgets.value = false;
                        showFinalResults.value = true;
                        showRecentSearch.value = false;
                        showChannelDetail.value = false;
                        showTotalChannel.value = false;
                        _navigateToResultsPage(
                            context, searchQueryState.value); // 결과 페이지로 이동
                      },
                    );
                  },
                  loading: () => CircularLoading(),
                  error: (error, stackTrace) =>
                      ErrorMessage(message: '${error}'),
                ) : CustomScrollView(
                  slivers: [
                    // 채널 목록
                    // 채널 목록 (가로 스크롤 방식)
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 16, top: 24),
                            child: Text(
                              '인플루언서',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          SizedBox(
                            height: 210.w, // 채널 카드 높이
                            child: PagedListView<int, ChannelData>(
                              scrollDirection: Axis.horizontal,
                              pagingController: channelPagingController.value,
                              builderDelegate: PagedChildBuilderDelegate<ChannelData>(
                                itemBuilder: (context, channel, index) {
                                  return Padding(
                                    padding: EdgeInsets.only(
                                      left: index == 0 ? 16.0 : 8.0, // 첫 번째 항목은 왼쪽에 여백 추가
                                      right: index == channelPagingController
                                          .value.itemList!.length -
                                          1
                                          ? 16.0
                                          : 8.0, // 마지막 항목은 오른쪽에 여백 추가
                                    ),
                                    child: ChannelItem(
                                      key: ValueKey(channel.id),
                                      channelData: channel,
                                      size: 0.4.sw, // 크기 조정
                                      onChannelItemClick: () => onChannelItemClick(channel),
                                    ),
                                  );
                                },
                                firstPageProgressIndicatorBuilder: (_) =>
                                    Center(child: CircularLoading()),
                                newPageProgressIndicatorBuilder: (_) =>
                                    Center(child: CircularLoading()),
                                noItemsFoundIndicatorBuilder: (_) =>
                                    EmptyMessage(message: '검색된 인플루언서가 없습니다.'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 필터 레시피
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: FilterRecipe(
                          selectedFilter: selectedFilter,
                          showFilterOptions: showFilterOptions,
                          onFilterChanged: (filter) {
                            selectedSort.value = filter == FilterOption.latest
                                ? 'created_at DESC' // 최신순
                                : 'popularity DESC'; // 인기순
                            videoPagingController.value.refresh();
                          },
                        ),
                      ),
                    ),
                    // 비디오 목록
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text('레시피 영상', style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: PagedSliverList<int, VideoData>(
                        pagingController: videoPagingController.value,
                        builderDelegate: PagedChildBuilderDelegate<VideoData>(
                          itemBuilder: (context, video, index) {
                            return VideoItem(
                              key: ValueKey(video.id),
                              video: video,
                              size: 0.22.sw,
                              titleWidth: 0.6.sw,
                              channelWidth: 0.35.sw,
                              onVideoItemClick: () {},
                            );
                          },
                          firstPageProgressIndicatorBuilder: (_) =>
                              Center(child: CircularLoading()),
                          newPageProgressIndicatorBuilder: (_) =>
                              Center(child: CircularLoading()),
                          noItemsFoundIndicatorBuilder: (_) =>
                              EmptyMessage(message: '검색된 비디오가 없습니다.'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 슬라이드 애니메이션 함수
  Widget _buildSlideTransition(Widget child, Animation<double> animation) {
    // 뒤로가기 시 애니메이션 방향을 역으로 설정

    // final offset = isBackwards ? Offset(-1.0, 0.0) : Offset(1.0, 0.0);
    // final slideAnimation = Tween<Offset>(begin: offset, end: Offset.zero).animate(animation);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut, // 부드러운 시작과 끝
      ),
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
  }

  // 결과 페이지로 이동하는 메서드 (슬라이드 애니메이션 추가)
  void _navigateToResultsPage(BuildContext context, String searchQuery) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ResultSearchAlgoria(
          searchQuery: searchQuery,
          onChannelItemClick: (channelData) {
            // 채널 클릭 시 채널 상세 페이지로 이동
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ResultSearchChannel(
                  channelData: channelData,
                ),
              ),
            );
            // Navigator.push(
            //   context,
            //   PageRouteBuilder(
            //     pageBuilder: (context, animation, secondaryAnimation) =>
            //         ResultSearchChannel(
            //           channelData: channelData,
            //         ),
            //     transitionsBuilder:
            //         (context, animation, secondaryAnimation, child) {
            //       const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
            //       const end = Offset.zero;
            //       const curve = Curves.easeInOut;
            //
            //       var tween = Tween(begin: begin, end: end)
            //           .chain(CurveTween(curve: curve));
            //       var offsetAnimation = animation.drive(tween);
            //
            //       return SlideTransition(
            //         position: offsetAnimation,
            //         child: child,
            //       );
            //     },
            //   ),
            // );
          },
          onTotalChannelClick: (String totalChannel) {
            // 전체 채널 클릭 시 TotalChannels 페이지로 이동
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    Totalchannels(
                      searchQuery: totalChannel,
                      onChannelItemClick: (channelData) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                ResultSearchChannel(
                                  channelData: channelData,
                                ),
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
