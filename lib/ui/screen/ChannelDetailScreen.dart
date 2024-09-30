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

class ChannelDetailScreen extends HookConsumerWidget {
  final ChannelData channelData; // 채널 데이터를 받는 파라미터

  const ChannelDetailScreen({
    Key? key,
    required this.channelData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilter = useState<FilterOption>(FilterOption.viewCount); // 필터
    final showFilterOptions = useState<bool>(false); // 필터 옵션 보이기 여부
    final pagingController = PagingController<int, QueryDocumentSnapshot>(
      firstPageKey: 0, // 첫 페이지 키 초기화
    );

    // 비디오 리스트 데이터 가져오기
    final fetchVideos = (int pageKey) async {
      try {
        // 검색 파라미터 설정
        final searchParams = {
          'channel_id': channelData.id,
          'filter': selectedFilter.value,
          'start_after': pageKey == 0 ? null : pagingController.itemList!.last,
        };

        // 비디오 로드 요청을 위한 스크롤 시간 지연
        await Future.delayed(Duration(milliseconds: 500)); // 500ms 지연

        // Firestore 쿼리로 비디오 가져오기
        final newVideos =
            await ref.read(videosByChannelProvider(searchParams).future);

        final isLastPage = newVideos.isEmpty; // 더 이상 데이터가 없는 경우
        if (isLastPage) {
          pagingController.appendLastPage(newVideos);
        } else {
          final nextPageKey = pageKey + newVideos.length; // 다음 페이지 키 계산
          pagingController.appendPage(newVideos, nextPageKey);
        }
      } catch (error) {
        pagingController.error = error; // 오류 발생 시 처리
      }
    };

    useEffect(() {
      pagingController.addPageRequestListener(fetchVideos); // 페이지 요청 리스너 추가
      return () =>
          pagingController.removePageRequestListener(fetchVideos); // 클린업
    }, [pagingController]);

    return Scaffold(
      appBar: AppBar(
          titleSpacing: 0, // 타이틀과 leading 아이콘 사이의 기본 간격을 없앱니다.
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: IconButton(
              icon: Icon(Icons.arrow_back_ios), // 여기서 원하는 아이콘으로 변경
              onPressed: () {
                Navigator.of(context).pop(); // 이전 화면으로 이동
              },
            ),
          ),
          title: Text(
        channelData.channelName,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
      )
      ),
      body: CustomScrollView(
        // CustomScrollView를 사용
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 상단 위젯들
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 24),
                  child: Text('인플루언서',
                      style: Theme.of(context).textTheme.labelLarge),
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
              pagingController: pagingController,
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
          if (pagingController.error != null)
            SliverToBoxAdapter(
              child: ErrorMessage(message: '오류 발생: ${pagingController.error}'),
            ),
        ],
      ),
    );
  }
}
