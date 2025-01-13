import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/AlgoliaService.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Totalchannels extends HookConsumerWidget {
  final String searchQuery;
  final Function(ChannelData) onChannelItemClick; // 콜백 추가

  Totalchannels({
    Key? key,
    required this.searchQuery,
    required this.onChannelItemClick, // 콜백 받기
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final algoliaService = AlgoliaService();
    final searchQueryState = useState<String>(searchQuery); // 상태 변수로 검색어 관리

    final channelPagingController = useState(
      PagingController<int, ChannelData>(firstPageKey: 0),
    );

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
      channelPagingController.value.addPageRequestListener(fetchChannels);
      fetchChannels(0);
      return () {
        channelPagingController.value.removePageRequestListener(fetchChannels);
      };
    }, [searchQueryState.value]);

    return Scaffold(
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 12),
                  Text(
                    '인플루언서',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 16), // 텍스트와 그리드 간 간격
                ],
              ),
            ),
            PagedSliverGrid<int, ChannelData>(
              pagingController: channelPagingController.value,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 줄에 두 개의 아이템
                mainAxisSpacing: 24, // 세로 간격
                crossAxisSpacing: 16, // 가로 간격
                childAspectRatio: 0.8, // 가로 세로 비율
              ),
              builderDelegate: PagedChildBuilderDelegate<ChannelData>(
                itemBuilder: (context, channel, index) {
                  debugPrint('채널 아이템: ${channel.thumbnailUrl}');
                  return ChannelItem(
                    key: ValueKey(channel.id),
                    channelData: channel,
                    size: 0.32.sw, // 크기 조정
                    onChannelItemClick: () => onChannelItemClick(channel),
                  );
                },
                firstPageProgressIndicatorBuilder: (_) =>
                    Center(child: CircularLoading()),
                newPageProgressIndicatorBuilder: (_) =>
                    Center(child: CircularLoading()),
                noItemsFoundIndicatorBuilder: (_) =>
                    Center(child: EmptyMessage(message: '검색된 인플루언서가 없습니다.')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}