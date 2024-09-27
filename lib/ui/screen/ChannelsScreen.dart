import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelsScreen extends HookConsumerWidget {
  final String searchQuery;
  // ChannelsScreen({super.key, required this.searchQuery});
  ChannelsScreen({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(); // TextEditingController 생성
    final query = useState<String>(searchQuery); // 검색 쿼리 상태 관리
    final recentSearches = useState<List<String>>([]); // 최근 검색어 상태 관리
    final showSearchWidgets = useState<bool>(false); // 검색 위젯 보이기 여부
    final showFinalResults = useState<bool>(true); // 최종 검색 결과 화면 제어
    final searchChannelListAsyncValue = ref.watch(searchTotalChannelProvider(query.value));

    final fb_searchResult = ref.watch(autoSearchChannelProvider(query.value));

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼을 숨김
        title: SearchBarWidget(
          searchQuery: query,
          searchController: searchController,
          recentSearches: recentSearches,
          onSearchTap: () {
            showSearchWidgets.value = true; // 자동 검색 화면 활성화
            showFinalResults.value = false; // 최종 검색 결과 숨기기
          },
          onBackPressed: () {
            GoRouter.of(context).pop();
            query.value = ''; // 검색 쿼리 초기화
            searchController.clear(); // 검색 컨트롤러 초기화
          },
          showBackButton: !showSearchWidgets.value,
          // 뒤로가기 버튼 표시 여부
          onSubmitted: () {
            // 검색 완료 시
            showSearchWidgets.value = false; // 자동 검색 화면 숨기기
            showFinalResults.value = true; // 최종 검색 결과 화면 보이기
          },
          enabled: true, // ResultSearch가 true일 때 enabled 설정
        ),
      ),
      body: showFinalResults.value
          ? buildSingleChildScrollView(searchChannelListAsyncValue,context)
          : showSearchWidgets.value
          ? fb_searchResult.when(
        data: (results) {
          // 검색 결과가 있는 경우
          if (results.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(42),
              child: Center(
                child: EmptyMessage(
                    message:
                    '쿡플루언서 검색 결과가 없습니다.'), // 결과가 없을 때 메시지
              ),
            );
          }
          return AutoSearch(
            results: results,
            searchQuery: query,
            searchController: searchController,
            onSubmitted: () {
              // 엔터 누르기 동작을 처리
              showSearchWidgets.value = false; // 자동 검색 화면 숨기기
              showFinalResults.value = true; // 최종 검색 결과 화면 보이기
            },
          ); // 검색 결과 위젯 반환
        },
        loading: () => CircularLoading(),
        error: (error, stackTrace) =>
            ErrorMessage(message: '${error}'),
      )
          : Container() // 검색 결과 화면
    );
  }

  SingleChildScrollView buildSingleChildScrollView(AsyncValue<List<QueryDocumentSnapshot<Object?>>> searchChannelListAsyncValue, BuildContext context) {
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
                      size: ScreenUtil.width(context, 0.32),
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

