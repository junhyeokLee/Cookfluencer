import 'package:cookfluencer/common/AlgoliaService.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class AutoSearch2 extends HookConsumerWidget {
  AutoSearch2({
    super.key,
    required this.searchQuery,
    required this.onSubmitted,
  });

  final ValueNotifier<String> searchQuery;
  final VoidCallback onSubmitted;

  // 통합된 검색 결과에 대한 PagingController
  final PagingController<int, dynamic> _pagingController = PagingController(firstPageKey: 0);

  // AlgoliaService 인스턴스
  final AlgoliaService _algoliaService = AlgoliaService();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 로딩 상태 관리
    final isLoading = useState<bool>(true);

    useEffect(() {
      final queryListener = () {
        final query = searchQuery.value.trim();
        if (query.isNotEmpty) {
          isLoading.value = true; // 로딩 시작
          _pagingController.refresh();
        } else {
          _pagingController.itemList = [];
          isLoading.value = false; // 검색어 없으면 로딩 중지
        }
      };

      searchQuery.addListener(queryListener);

      _pagingController.addPageRequestListener((pageKey) {
        if (searchQuery.value.isNotEmpty) {
          _fetchResults(searchQuery.value, pageKey, isLoading);
        }
      });

      return () {
        searchQuery.removeListener(queryListener);
        _pagingController.dispose();
      };
    }, []);

    return Stack(
      children: [
        // 결과 화면
        _buildResults(context),
        // 로딩 화면
        if (isLoading.value)
          const Center(child: CircularLoading()), // 로딩 화면
      ],
    );
  }

  Future<void> _fetchResults(String query, int pageKey, ValueNotifier<bool> isLoading) async {
    try {
      print('Fetching results for query: $query, pageKey: $pageKey');

      final channelPage = await _algoliaService.searchChannel(query, pageKey).first;
      final titlePage = await _algoliaService.searchTitle(query, pageKey).first;

      print('Fetched Channels: ${channelPage.channels.length}');
      print('Fetched Videos: ${titlePage.videos.length}');

      // 데이터 병합
      final combinedResults = [
        ...channelPage.channels,
        ...titlePage.videos,
      ];
      print('Combined Results: ${combinedResults.length}');
      // 다음 페이지 키 계산
      final isLastPage = channelPage.nextPageKey == null && titlePage.nextPageKey == null;
      final nextPageKey = isLastPage ? null : pageKey + 1;

      print('Is Last Page: $isLastPage');
      print('Next Page Key: $nextPageKey');

      if (pageKey == 0) {
        _pagingController.itemList = combinedResults; // 첫 페이지 데이터 설정
      } else {
        _pagingController.appendPage(combinedResults, nextPageKey); // 다음 페이지 데이터 추가
      }

      isLoading.value = false; // 로딩 상태 해제
    } catch (e) {
      print('Error fetching results: $e');
      _pagingController.error = e;
      isLoading.value = false; // 에러 발생 시 로딩 중지
    }
  }

  Widget _buildResults(BuildContext context) {
    return PagedListView<int, dynamic>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<dynamic>(
        noItemsFoundIndicatorBuilder: (_) => const Center(
          child: Text('검색 결과가 없습니다.'),
        ),
        itemBuilder: (_, item, __) {
          if (item is ChannelData) {
            return GestureDetector(
              onTap: () {
                searchQuery.value = item.channelName ?? 'Unknown Channel';
                onSubmitted();
              },
              child: _buildChannelItem(context, item),
            );
          } else if (item is VideoData) {
            return GestureDetector(
              onTap: () {
                searchQuery.value = item.title ?? 'Unknown Title';
                onSubmitted();
              },
              child: _buildVideoItem(context, item),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        // newPageProgressIndicatorBuilder: (_) => Padding(
        //   padding: const EdgeInsets.symmetric(vertical: 8),
        //   child: Center(child: CircularLoading()),
        // ),
      ),
    );
  }

  Widget _buildChannelItem(BuildContext context, ChannelData channel) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundColor, // 채널 색상 강조
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.search,
              size: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              channel.channelName ?? 'Unknown Channel',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoItem(BuildContext context, VideoData video) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.backgroundColor, // 비디오 기본 색상
            ),
            padding: const EdgeInsets.all(6),
            child: Icon(
              Icons.search,
              size: 12,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              video.title ?? 'Unknown Title',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ),
        ],
      ),
    );
  }
}
