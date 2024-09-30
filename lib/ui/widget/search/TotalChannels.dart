import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class Totalchannels extends HookConsumerWidget {
  final String searchQuery;
  final Function(ChannelData) onChannelItemClick; // 콜백 추가

  Totalchannels({Key? key,
    required this.searchQuery,
    required this.onChannelItemClick, // 콜백 받기
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchChannelListAsyncValue = ref.watch(searchTotalChannelProvider(searchQuery));
    return Scaffold(
        body: buildSingleChildScrollView(searchChannelListAsyncValue,context)
    );
  }

  SingleChildScrollView buildSingleChildScrollView(AsyncValue<List<QueryDocumentSnapshot<Object?>>> searchChannelListAsyncValue,
      BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24),
            child: Text('인플루언서',
                style: Theme.of(context).textTheme.labelLarge),
          ),

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
                    mainAxisSpacing: 24, // 아이템 간 세로 간격
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
                      size: ScreenUtil.width(context, 0.32), onChannelItemClick: () {
                      onChannelItemClick(channelData); // 콜백 호출
                    },
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
    );
  }
}

