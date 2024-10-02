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
  const ResultSearchChannel({Key? key,
    required this.channelData,
  }) : super(key: key);

  final ChannelData channelData; // 채널 데이터를 받는 파라미터


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount);
    final showFilterOptions = useState<bool>(false);
    final pagingController = useState(PagingController<int, QueryDocumentSnapshot>(
      firstPageKey: 0,
    ));
    // 비디오 리스트 데이터 가져오기
    Future<void> fetchVideos(int pageKey) async {
      try {
        final searchParams = {
          'channel_id': channelData.id,
          'filter': selectedFilter.value,
          'start_after': pageKey == 0 ? null : pagingController.value.itemList!.last,
        };

        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        final newVideos = await ref.read(videosByChannelProvider(searchParams).future);

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
      fetchVideos(0);  // 이제 이 호출이 올바르게 작동합니다.
      return null; // clean up 함수 반환
    }, [selectedFilter.value]);

    useEffect(() {
      // PagingController에 페이지 요청 리스너 추가
      pagingController.value.addPageRequestListener(fetchVideos);
      return () => pagingController.value.removePageRequestListener(fetchVideos);
    }, [pagingController.value]);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Padding(
                padding: const EdgeInsets.only(left: 16, top: 24),
                child: Text('인플루언서',
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelLarge),
              ),
              ChannelItemHorizontal(channelData: channelData),
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
                  viewCount:
                  int.tryParse(video['view_count'].toString()) ?? 0,
                  section: video['section'] ?? '',
                );
                return VideoItem(
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
            child: ErrorMessage(message: '오류 발생: ${pagingController.value.error}'),
          ),
      ],
    );
  }
}
