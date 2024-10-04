import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ResultSearchChannel extends HookConsumerWidget {
  const ResultSearchChannel({
    Key? key,
    required this.channelData,
  }) : super(key: key);

  final ChannelData channelData; // 채널 데이터를 받는 파라미터

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount);
    final showFilterOptions = useState<bool>(false);
    final pagingController =
        useState(PagingController<int, QueryDocumentSnapshot>(
      firstPageKey: 0,
    ));

    // 초기 렌더링 상태를 추적하기 위한 변수
    final initialFetch = useState<bool>(true);

    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final lastDocument =
            pageKey == 0 ? null : pagingController.value.itemList?.last;

        final searchParams = {
          'channel_id': channelData.id,
          'filter': selectedFilter.value,
          'start_after': lastDocument,
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos =
            await ref.read(videosByChannelProvider(searchParams).future);

        // 기존 비디오 ID를 Set으로 가져와서 중복 체크
        final existingIds =
            pagingController.value.itemList?.map((item) => item.id).toSet() ??
                {};

        // 새로운 비디오 리스트에서 이미 있는 비디오를 필터링
        final filteredVideos = newVideos
            .where((video) => !existingIds.contains(video.id))
            .toList();

        // 중복 체크 후 비디오가 없으면 lastPage로 설정
        final isLastPage = filteredVideos.isEmpty;
        if (isLastPage) {
          pagingController.value.appendLastPage(filteredVideos);
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


    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24),
                child: Text('인플루언서',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              ChannelItemHorizontal(
                channelData: channelData,
                onChannelItemClick: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16, top: 12, bottom: 12, right: 20),
                child: Text('레시피 영상',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12, right: 20),
                child: FilterRecipe(
                  selectedFilter: selectedFilter,
                  showFilterOptions: showFilterOptions,
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
                  video: videoData,
                  size: ScreenUtil.width(context, 0.2),
                  titleWidth: ScreenUtil.width(context, 0.65),
                  channelWidth: ScreenUtil.width(context, 0.35),
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
    );
  }
}
