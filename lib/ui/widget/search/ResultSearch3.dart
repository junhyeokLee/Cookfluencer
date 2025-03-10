import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/CustomRoundButton.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchChannel.dart';
import 'package:cookfluencer/ui/widget/search/TotalChannels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultSearch3 extends HookConsumerWidget {
  final String searchQuery;
  final Function(ChannelData) onChannelItemClick; // 콜백 추가
  final Function(String) onTotalChannelClick; // 콜백 추가


  const ResultSearch3({
    super.key,
    required this.searchQuery,
    required this.onChannelItemClick, // 콜백 받기
    required this.onTotalChannelClick, // 콜백 받기
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.latest);
    final showFilterOptions = useState<bool>(false);

    final pagingController = useState(PagingController<int, QueryDocumentSnapshot>(
      firstPageKey: 0,
    ));



    final searchChannelListAsyncValue = ref.watch(searchChannelProvider(searchQuery));
    final initialFetch = useState<bool>(true);

    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final lastDocument =
        pageKey == 0 ? null : pagingController.value.itemList?.last;

        final searchParams = {
          'query': searchQuery,
          'filter': selectedFilter.value,
          'start_after': lastDocument
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos =
        await ref.read(searchFilterVideoProvider(searchParams).future);

        final existingIds =
            pagingController.value.itemList?.map((item) => item.id).toSet() ??
                {};

        // 새로운 비디오 리스트에서 이미 있는 비디오를 필터링
        final filteredVideos = newVideos
            .where((video) => !existingIds.contains(video))
            .toList();

        // 중복 체크 후 비디오가 없으면 lastPage로 설정
        final isLastPage = filteredVideos.isEmpty;
        if (isLastPage) {
          pagingController.value.appendLastPage(filteredVideos.cast<QueryDocumentSnapshot<Object?>>());
        } else {
          final nextPageKey = pageKey + filteredVideos.length; // 다음 페이지 키 계산
          pagingController.value.appendPage(filteredVideos.cast<QueryDocumentSnapshot<Object?>>(), nextPageKey);
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
      final newPagingController = PagingController<int, QueryDocumentSnapshot>(
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


    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
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
                                padding: const EdgeInsets.only(left: 16, top: 24),
                                child: Text('인플루언서',
                                    style: Theme.of(context).textTheme.titleLarge),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20),
                                height: 210.w,
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

                                    final paddingLeft = index == 0 ? 16.0 : 24.0;
                                    final paddingRight = 0.0;

                                    return Padding(
                                      padding: EdgeInsets.only(
                                          left: paddingLeft, right: paddingRight),
                                      child: ChannelItem(
                                        key: ValueKey(channelData.id),
                                        // GlobalKey 대신 ValueKey 사용
                                        channelData: channelData,
                                        size: 0.4.sw,
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
                                    left: 16, top: 12, right: 24, bottom: 24),
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
                        padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
                        child: Text('레시피 영상',
                            style: Theme.of(context).textTheme.titleLarge),
                      ),

                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16, right: 16),
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
                          recipe: video['recipe'] != null
                              ? RecipeData(
                            video_id: video['recipe']['video_id'] ?? '',
                            description: video['recipe']['description'] ?? '',
                            cookingTime: video['recipe']['cooking_time'] ?? '',
                            level: video['recipe']['level'] ?? '',
                            tip_knowhow: video['recipe']['tip_knowhow'] ?? '',
                            finishing: video['recipe']['finishing'] ?? '',
                            ingredients: video['recipe']['ingredients'] ?? '',
                            equipment: video['recipe']['equipment'] ?? '',
                            cookingMethods: video['recipe']['cooking_methods'] ?? '',
                          ) : RecipeData(), // 레시피가 없으면 기본 RecipeData 객체 생성
                          section: video['section'] ?? '',
                        );
                        return VideoItem(
                          key: ValueKey(videoData.id),
                          // 고유한 ID를 사용해 ValueKey 설정
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
                    child:
                    ErrorMessage(message: '오류 발생: ${pagingController.value.error}'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 결과 페이지로 이동하는 메서드 (슬라이드 애니메이션 추가)
  void _navigateToResultsPage(BuildContext context, String searchQuery) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ResultSearch3(
          searchQuery: searchQuery,
          onChannelItemClick: (channelData) {
            // 채널 클릭 시 채널 상세 페이지로 이동
            Navigator.push(
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) => ResultSearchChannel(
                  channelData: channelData,
                ),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
                  const end = Offset.zero;
                  const curve = Curves.easeInOut;

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
                pageBuilder: (context, animation, secondaryAnimation) => Totalchannels(
                  searchQuery: totalChannel,
                  onChannelItemClick: (channelData) {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) => ResultSearchChannel(
                          channelData: channelData,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0); // 오른쪽에서 왼쪽으로 슬라이드
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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

                  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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

          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
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
