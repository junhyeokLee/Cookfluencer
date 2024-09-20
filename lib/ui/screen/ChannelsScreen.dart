import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelsScreen extends HookConsumerWidget {
  const ChannelsScreen({super.key, required this.searchQuery});

  final String searchQuery;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(); // TextEditingController 생성
    final searchChannelListAsyncValue = ref.watch(searchTotalChannelProvider(searchQuery));

    return Scaffold(
      appBar: AppBar(
        title: Container(
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.grey)), // 밑줄 추가
          ),
          child: Row(
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
                onPressed: () {
                  context.pop(); // 뒤로가기
                },
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Text(
                      '${searchQuery}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                    GestureDetector(
                      onTap: false ? () {} : null, // enabled가 true일 때만 클릭 이벤트 허용
                      child: AbsorbPointer(
                        absorbing: false, // enabled가 false일 때 클릭 및 포커스 차단
                        child: TextField(
                          style: Theme.of(context).textTheme.bodyLarge,
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            searchChannelListAsyncValue.when(
              data: (channels) {
                if (channels.isEmpty) {
                  return Center(
                    child: EmptyMessage(message: '쿡플루언서 검색 결과가 없습니다.'),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // 한 줄에 두 개의 아이템을 배치
                      crossAxisSpacing: 12, // 아이템 간 가로 간격
                      mainAxisSpacing: 12, // 아이템 간 세로 간격
                      childAspectRatio: 1, // 아이템의 가로 세로 비율
                    ),
                    itemCount: channels.length,
                    itemBuilder: (context, index) {
                      final channel = channels[index].data() as Map<String, dynamic>;

                      // ChannelModel에 데이터를 맵핑
                      final channelData = ChannelData(
                        id: channel['id'] ?? 'Unknown',
                        channelName: channel['channel_name'] ?? 'Unknown',
                        channelDescription: channel['channel_description'] ?? '',
                        channelUrl: channel['channel_url'] ?? '',
                        thumbnailUrl: channel['thumbnail_url'] ?? '',
                        subscriberCount: int.tryParse(channel['subscriber_count'].toString()) ?? 0,
                        videoCount: channel['video_count'] ?? 0,
                        videos: channel['videos'] ?? [],
                        section: channel['section'] ?? '',
                      );
                      return ChannelItem(
                        channelData :channelData , // 채널 아이템 크기 조정
                        size: ScreenUtil.width(context, 0.5),
                      );
                    },
                  ),
                );
              },
              loading: () => CircularLoading(),
              error: (error, stackTrace) => ErrorMessage(message: '${error}'),
            ),
          ],
        ),
      ),
    );
  }
}