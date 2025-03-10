import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/AlgoliaService.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/CustomRoundButton.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch2.dart';
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
import '../../../data/recipeData.dart';
import '../AdNativeBottom.dart';

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

    final selectedSort = useState<String>('upload_date'); // 기본값 최신순


    // 📌 Firebase에서 특정 레시피 문서의 서브컬렉션을 가져오는 함수
    Future<List<T>> _fetchSubCollection<T>(
        String recipeId,
        String subCollectionName,
        T Function(Map<String, dynamic>) fromJson,
        ) async {
      try {
        QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
            .collection('recipe')
            .doc(recipeId)
            .collection(subCollectionName)
            .get();

        return subCollectionSnapshot.docs.map((doc) {
          return fromJson(doc.data() as Map<String, dynamic>);
        }).toList();
      } catch (e) {
        print("Error fetching $subCollectionName for recipe $recipeId: $e");
        return [];
      }
    }

    // 📌 Firebase에서 video_id가 같은 레시피를 가져오는 함수
    Future<List<RecipeData>> _fetchRecipesForVideo(String videoId) async {
      try {
        if (videoId.isEmpty) return [];

        QuerySnapshot recipeSnapshot = await FirebaseFirestore.instance
            .collection('recipe')
            .where('video_id', isEqualTo: videoId)
            .get();

        return await Future.wait(recipeSnapshot.docs.map((doc) async {
          final recipeData = RecipeData.fromJson(doc.data() as Map<String, dynamic>);

          List<CookingMethod> cookingMethods = await _fetchSubCollection<CookingMethod>(
            doc.id, 'cooking_methods', CookingMethod.fromJson,
          );
          List<Ingredient> ingredients = await _fetchSubCollection<Ingredient>(
            doc.id, 'ingredients', Ingredient.fromJson,
          );
          List<Equipment> equipment = await _fetchSubCollection<Equipment>(
            doc.id, 'equipment', Equipment.fromJson,
          );

          return recipeData.copyWith(
            cookingMethods: cookingMethods,
            ingredients: ingredients,
            equipment: equipment,
          );
        }).toList());
      } catch (e) {
        print("Error fetching recipes for video: $e");
        return [];
      }
    }

    // 📌 Algolia에서 검색된 비디오에 Firebase의 레시피를 추가하는 함수
    Future<void> fetchVideos(int pageKey) async {
      try {
        final videoResults = await algoliaService
            .searchTitleFilter(searchQueryState.value, pageKey, selectedSort.value)
            .first;

        final List<VideoData> newVideos = await Future.wait(
          videoResults.videos.map((video) async {
            List<RecipeData> recipes = await _fetchRecipesForVideo(video.videoId);
            return video.copyWith(recipe: recipes.isNotEmpty ? recipes[0] : RecipeData());
          }).toList(),
        );

        final isLastPage = newVideos.length < 20;
        if (isLastPage) {
          videoPagingController.value.appendLastPage(newVideos);
        } else {
          final nextPageKey = pageKey + 1;
          videoPagingController.value.appendPage(newVideos, nextPageKey);
        }
      } catch (error) {
        videoPagingController.value.error = error;
      }
    }

    // Future<void> fetchVideos(int pageKey) async {
    //   try {
    //     final videoResults = await algoliaService.searchTitleFilter(searchQueryState.value, pageKey, selectedSort.value).first;
    //       print("Fetched Videos Count: ${videoResults.videos.length}");
    //     for (var video in videoResults.videos) {
    //       print("Video ID: ${video.id}, Title: ${video.title}");
    //     }
    //     final newVideos = videoResults.videos;
    //
    //     // 페이지 끝 판단
    //     final isLastPage = newVideos.length < 20;
    //
    //     if (isLastPage) {
    //       videoPagingController.value.appendLastPage(newVideos);
    //     } else {
    //       final nextPageKey = pageKey + 1;
    //
    //       // 중복 제거된 데이터가 없더라도 다음 페이지 요청
    //       videoPagingController.value.appendPage(newVideos, nextPageKey);
    //     }
    //   } catch (error) {
    //     videoPagingController.value.error = error;
    //   }
    // }

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
      // fetchVideos(0);
      // fetchChannels(0);
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
                            padding: const EdgeInsets.only(left: 16, top: 24, bottom: 12),
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
                                onTotalChannelClick(searchQueryState.value); // 콜백 호출
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: AdNativeBottom(),
                    ),
                    // 비디오 목록
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 16.0,top: 16),
                        child: Text('레시피 영상', style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ),
                    // 필터 레시피
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 22,top: 0 ,bottom: 32),
                        child: FilterRecipe(
                          selectedFilter: selectedFilter,
                          showFilterOptions: showFilterOptions,
                          onFilterChanged: (filter) {
                            selectedSort.value = filter == FilterOption.latest
                                ? 'upload_date' // 최신순
                                : 'view_count'; // 인기순
                            videoPagingController.value.refresh();
                          },
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: PagedSliverList<int, VideoData>(
                        pagingController: videoPagingController.value,
                        builderDelegate: PagedChildBuilderDelegate<VideoData>(
                          itemBuilder: (context, video, index) {
                            debugPrint("레시피 확인: ${video.recipe}");
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
