import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/CustomRoundButton.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch2.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchChannel.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:cookfluencer/ui/widget/search/TotalChannels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

    // 키보드 닫는 기능 추가
    void _dismissKeyboard() {
      FocusScope.of(context).unfocus();
    }

    final pagingController = useState(PagingController<int, Map<String, dynamic>>(
      firstPageKey: 0,
    ));

    final searchChannelListAsyncValue =
    ref.watch(searchChannelProvider(searchQuery));

    final fb_searchResult =
    ref.watch(autoSearchChannelAndVideoProvider(searchQueryState.value));

    final initialFetch = useState<bool>(true);

    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        // pageKey가 0일 경우 마지막 문서가 없으므로 null로 설정
        final lastDocument = pageKey == 0 ? null : pagingController.value.itemList?.last['document_snapshot'];

        final searchParams = {
          'query': searchQueryState.value,
          'filter': selectedFilter.value,
          'start_after': lastDocument,
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        // 새로운 비디오 데이터 가져오기
        final newVideos = await ref.read(searchFilterVideoProvider(searchParams).future);

        // 중복 체크
        final existingIds = pagingController.value.itemList?.map((item) => item).toSet() ?? {};
        final filteredVideos = newVideos.where((video) => !existingIds.contains(video['id'])).toList();

        // 중복 체크 후 비디오가 없으면 lastPage로 설정
        final isLastPage = filteredVideos.isEmpty;
        if (isLastPage) {
          pagingController.value.appendLastPage(filteredVideos); // filteredVideos를 그대로 추가
        } else {
          final nextPageKey = pageKey + filteredVideos.length; // 다음 페이지 키 계산
          pagingController.value.appendPage(filteredVideos, nextPageKey);
        }
      } catch (error) {
        pagingController.value.error = error; // 오류 발생 시 처리
      }
    }

    useEffect(() {
      // PagingController의 요청 리스너 제거
      final previousController = pagingController.value;
      previousController.removePageRequestListener((pageKey) {
        fetchVideos(pageKey);
      });

      // 새로운 PagingController 생성
      final newPagingController = PagingController<int, Map<String, dynamic>>(
        firstPageKey: 0,
      );

      // 페이지 요청 리스너 추가
      newPagingController.addPageRequestListener((pageKey) {
        fetchVideos(pageKey);
      });

      // PagingController를 새로운 것으로 설정
      pagingController.value = newPagingController;

      // 필터가 변경될 때만 비디오 리스트를 새로 가져오기
      if (!initialFetch.value) {
        fetchVideos(0); // 필터가 변경될 때만 호출
      } else {
        initialFetch.value = false; // 초기 fetch가 끝났음을 표시
      }
      // 클린업: 현재 PagingController의 페이지 요청 리스너 제거
      return () {
        previousController.removePageRequestListener((pageKey) {
          fetchVideos(pageKey);
        });
      };
    }, [selectedFilter.value]);

    return GestureDetector(
      onTap: _dismissKeyboard, // 화면 터치 시 키보드 닫기
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 0,
        ),
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
                _navigateToResultsPage(
                    context, searchQueryState.value); // 결과 페이지로 이동
                showSearchWidgets.value = false;
                showRecentSearch.value = true;
                showFinalResults.value = false;
                // 검색어를 초기화하는 부분 삭제
                // searchQuery.value = "";
                searchController.clear();
              },
              onBackPressed: () {
                context.pop();
              },
            ),
            // 채널 검색 결과 표시
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return _buildSlideTransition(child, animation);
                },
                child: searchFocus.value
                    ? fb_searchResult.when(
                  data: (results) {
                    if (results.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(42),
                        child: Center(
                          child:
                          EmptyMessage(message: '쿡플루언서 검색 결과가 없습니다.'),
                        ),
                      );
                    }
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
                      },
                    );
                  },
                  loading: () => CircularLoading(),
                  error: (error, stackTrace) =>
                      ErrorMessage(message: '${error}'),
                )
                    : CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          searchChannelListAsyncValue.when(
                            data: (channels) {
                              double screenHeight = MediaQuery.of(context).size.height;
                              double containerHeight = screenHeight < 600 ? screenHeight * 0.34 : screenHeight * 0.27;

                              if (channels.isEmpty) {
                                return Center(
                                  child: EmptyMessage(
                                      message: '검색된 쿡플루언서가 없습니다.'),
                                );
                              }
                              return Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, top: 24),
                                    child: Text('인플루언서',
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    height: 210.w,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: channels.length,
                                      itemBuilder: (context, index) {
                                        final channel = channels[index]
                                            .data() as Map<String, dynamic>;
                                        final channelData = ChannelData(
                                          id: channel['id'] ?? 'Unknown',
                                          channelName:
                                          channel['channel_name'] ??
                                              'Unknown',
                                          channelDescription: channel[
                                          'channel_description'] ??
                                              '',
                                          channelUrl:
                                          channel['channel_url'] ?? '',
                                          thumbnailUrl:
                                          channel['thumbnail_url'] ??
                                              '',
                                          subscriberCount: int.tryParse(
                                              channel['subscriber_count']
                                                  .toString()) ??
                                              0,
                                          videoCount:
                                          channel['video_count'] ?? 0,
                                          videos: channel['videos'] ?? [],
                                          section: channel['section'] ?? '',
                                        );

                                        final paddingLeft =
                                        index == 0 ? 16.0 : 24.0;
                                        final paddingRight = 0.0;

                                        return Padding(
                                          padding: EdgeInsets.only(
                                              left: paddingLeft,
                                              right: paddingRight),
                                          child: ChannelItem(
                                            key: ValueKey(channelData.id),
                                            // GlobalKey 대신 ValueKey 사용
                                            channelData: channelData,
                                            size: 0.4.sw,
                                            onChannelItemClick: () {
                                              onChannelItemClick(
                                                  channelData); // 콜백 호출
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16,
                                        top: 12,
                                        right: 24,
                                        bottom: 24),
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
                                        onTotalChannelClick(searchQueryState
                                            .value); // 콜백 호출
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
                            error: (error, stackTrace) =>
                                ErrorMessage(message: '${error}'),
                          ),

                          // 비디오 검색 결과 처리
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16, top: 12, bottom: 12),
                            child: Text('레시피 영상',
                                style:
                                Theme.of(context).textTheme.titleLarge),
                          ),

                          Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 16, right: 16),
                              child: FilterRecipe(
                                selectedFilter: selectedFilter,
                                showFilterOptions: showFilterOptions,
                                onFilterChanged: (filter) {

                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SliverPadding(
                      padding: const EdgeInsets.only(left: 16, right: 16),
                      sliver: PagedSliverList<int, Map<String, dynamic>>(
                        pagingController: pagingController.value,
                        builderDelegate: PagedChildBuilderDelegate<Map<String, dynamic>>(
                          itemBuilder: (context, video, index) {
                            // video는 Map<String, dynamic> 타입입니다.
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
                              recipe: video['recipe'] != null
                                  ? RecipeData(
                                video_id: video['recipe']['video_id'] ?? '',
                                description: video['recipe']['description'] ?? '',
                                cookingTime: video['recipe']['cooking_time'] ?? '',
                                level: video['recipe']['level'] ?? 0,
                                tip_knowhow: video['recipe']['tip_knowhow'] ?? '',
                                finishing: video['recipe']['finishing'] ?? '',
                                ingredients: video['recipe']['ingredients'] ?? [],
                                equipment: video['recipe']['equipment'] ?? [],
                                cookingMethods: video['recipe']['cooking_methods'] ?? [],
                              ) : RecipeData(), // 레시피가 없으면 기본 RecipeData 객체 생성
                              section: video['section'] ?? '',
                            );
                            return VideoItem(
                              key: ValueKey(videoData.id), // 고유한 ID를 사용해 ValueKey 설정
                              video: videoData,
                              size: 0.22.sw,
                              titleWidth: 0.6.sw,
                              channelWidth: 0.35.sw,
                              onVideoItemClick: () {},
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
                        child: ErrorMessage(
                            message:
                            '오류 발생: ${pagingController.value.error}'),
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
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ResultSearch(
          searchQuery: searchQuery,
          onChannelItemClick: (channelData) {
            // 채널 클릭 시 채널 상세 페이지로 이동
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    ResultSearchChannel(
                      channelData: channelData,
                    ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
          onTotalChannelClick: (String totalChannel) {
            // 전체 채널 클릭 시 TotalChannels 페이지로 이동
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    Totalchannels(
                      searchQuery: totalChannel,
                      onChannelItemClick: (channelData) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) =>
                                ResultSearchChannel(
                                  channelData: channelData,
                                ),
                            transitionsBuilder:
                                (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
                              const end = Offset.zero;
                              const curve = Curves.easeInOut;

                              var tween = Tween(begin: begin, end: end)
                                  .chain(CurveTween(curve: curve));
                              var offsetAnimation = animation.drive(tween);

                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      },
                    ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end)
                      .chain(CurveTween(curve: curve));
                  var offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
              ),
            );
          },
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );
  }
}