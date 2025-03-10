import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/VideoProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResultSearchChannel extends HookConsumerWidget {
  const ResultSearchChannel({
    Key? key,
    required this.channelData,
  }) : super(key: key);

  final ChannelData channelData; // 채널 데이터를 받는 파라미터

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.latest);
    final showFilterOptions = useState<bool>(false);
    final pagingController = useState(PagingController<int, Map<String, dynamic>>(
      firstPageKey: 0,
    ));

    // 키보드 닫는 기능 추가
    void _dismissKeyboard() {
      FocusScope.of(context).unfocus();
    }

    // 초기 렌더링 상태를 추적하기 위한 변수
    final initialFetch = useState<bool>(true);

    Future<void> fetchVideos(int pageKey) async {
      try {
        final lastDocument = pageKey == 0 ? null : pagingController.value.itemList?.last['document_snapshot'];

        final searchParams = {
          'channel_id': channelData.id,
          'filter': selectedFilter.value,
          'start_after': lastDocument
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos = await ref.read(videosByChannelProvider(searchParams).future);

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
        appBar: AppBar(
          titleSpacing: 0,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 24,bottom: 12),
                    child: Text('인플루언서',
                        style: Theme.of(context).textTheme.titleLarge ),
                  ),
                  ChannelItemHorizontal(
                    channelData: channelData,
                    onChannelItemClick: () {},
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 36, bottom: 12, right: 20),
                    child: Text('레시피 영상',
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:12,bottom: 14, right: 20),
                    child: FilterRecipe(
                      selectedFilter: selectedFilter,
                      showFilterOptions: showFilterOptions,
                      onFilterChanged: (filter) {

                      },
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
                child:
                ErrorMessage(message: '오류 발생: ${pagingController.value.error}'),
              ),
          ],
        ),
      ),
    );
  }
}
