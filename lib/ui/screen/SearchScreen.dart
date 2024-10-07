import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/PopularKeyword.dart';
import 'package:cookfluencer/ui/widget/search/RecentSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchChannel.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:cookfluencer/ui/widget/search/TotalChannels.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final searchQuery = useState<String>('');
    final recentSearches = useState<List<String>>([]);
    final showSearchWidgets = useState<bool>(true);
    final showFinalResults = useState<bool>(false);
    final showRecentSearch = useState<bool>(true);
    final showChannelDetail = useState<bool>(false);
    final showTotalChannel = useState<bool>(false);
    final selectedChannelData = useState<ChannelData?>(null);
    final selectedTotalChannel = useState<String>('');

    final fb_searchResult =
        ref.watch(autoSearchChannelAndVideoProvider(searchQuery.value));
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    useEffect(() {
      loadRecentSearches(recentSearches);
      return null;
    }, []);

    return Scaffold(
      appBar: AppbarWidget(), // 앱바 추가
      body: WillPopScope(
        onWillPop: () async {
          // 뒤로가기 처리 로직
          if (showChannelDetail.value || showTotalChannel.value) {
            showChannelDetail.value = false;
            showSearchWidgets.value = false;
            showTotalChannel.value = false;
            showFinalResults.value = true;
            return false;
          }

          if (showFinalResults.value || !showSearchWidgets.value) {
            showSearchWidgets.value = true;
            showFinalResults.value = false;
            showRecentSearch.value = true;
            searchQuery.value = '';
            searchController.clear();
            return false;
          }

          searchQuery.value = '';
          searchController.clear();
          return true;
        },
        child: Column(
          children: [
            SearchBarWidget(
              searchQuery: searchQuery,
              searchController: searchController,
              recentSearches: recentSearches,
              showChannelDetail: showChannelDetail.value,
              onSearchTap: () {
                // 검색 화면 상태 업데이트
                showSearchWidgets.value = false;
                showFinalResults.value = false;
                showRecentSearch.value = false;
                showChannelDetail.value = false;
                showTotalChannel.value = false;
              },
              onBackPressed: () {
                // 뒤로가기 버튼 처리
                if (showChannelDetail.value || showTotalChannel.value) {
                  showChannelDetail.value = false;
                  showSearchWidgets.value = false;
                  showFinalResults.value = true;
                  showTotalChannel.value = false;
                  return;
                }
                showSearchWidgets.value = true;
                showFinalResults.value = false;
                showRecentSearch.value = true;
                searchQuery.value = '';
                searchController.clear();
              },
              showBackButton: !showSearchWidgets.value,
              onSubmitted: () {
                // 검색 완료 시
                showSearchWidgets.value = false;
                showFinalResults.value = true;
                showRecentSearch.value = false;
                showChannelDetail.value = false;
                showTotalChannel.value = false;
              },
              enabled: true,
            ),
            Expanded(
              // Column의 자식이 여러 개일 경우 Expanded로 감싸서 공간을 확보
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return _buildSlideTransition(child, animation);
                },
                child: showTotalChannel.value
                    ? Totalchannels(
                        searchQuery: selectedTotalChannel.value,
                        onChannelItemClick: (channelData) {
                          showTotalChannel.value = false;
                          selectedChannelData.value = channelData;
                          showChannelDetail.value = true;
                        },
                      )
                    : showChannelDetail.value
                        ? ResultSearchChannel(
                            key: ValueKey(selectedChannelData.value?.id),
                            channelData: selectedChannelData.value!,
                          )
                        : showFinalResults.value
                            ? ResultSearch(
                                key: ValueKey(searchQuery.value),
                                searchQuery: searchQuery.value,
                                onChannelItemClick: (channelData) {
                                  selectedChannelData.value = channelData;
                                  showChannelDetail.value = true;
                                },
                                onTotalChannelClick: (String) {
                                  selectedTotalChannel.value = String;
                                  showTotalChannel.value = true;
                                },
                              )
                            : showSearchWidgets.value
                                ? Column(
                                    key: ValueKey('searchWidgets'),
                                    children: [
                                      RecentSearch(
                                        recentSearches: recentSearches,
                                        searchQuery: searchQuery,
                                        searchController: searchController,
                                        onSubmitted: () {
                                          showSearchWidgets.value = false;
                                          showFinalResults.value = true;
                                          showRecentSearch.value = false;
                                          showChannelDetail.value = false;
                                          showTotalChannel.value = false;
                                        },
                                      ),
                                      keywordListAsyncValue.when(
                                        data: (keywords) {
                                          List<Map<String, dynamic>>
                                              keywordList = keywords
                                                  .map((doc) => doc.data()
                                                      as Map<String, dynamic>)
                                                  .toList();
                                          return Popularkeyword(
                                            keywordList: keywordList,
                                            searchQuery: searchQuery,
                                            onSubmitted: () {
                                              showSearchWidgets.value = false;
                                              showFinalResults.value = true;
                                              showRecentSearch.value = false;
                                              showChannelDetail.value = false;
                                              showTotalChannel.value = false;
                                            },
                                            searchController: searchController,
                                          );
                                        },
                                        loading: () => CircularLoading(),
                                        error: (error, stackTrace) =>
                                            ErrorMessage(message: '${error}'),
                                      ),
                                    ],
                                  )
                                : fb_searchResult.when(
                                    data: (results) {
                                      if (results.isEmpty) {
                                        return Padding(
                                          padding: const EdgeInsets.all(42),
                                          child: Center(
                                            child: EmptyMessage(
                                                message: '쿡플루언서 검색 결과가 없습니다.'),
                                          ),
                                        );
                                      }
                                      return AutoSearch(
                                        key: ValueKey('autoSearch'),
                                        results: results,
                                        searchQuery: searchQuery,
                                        searchController: searchController,
                                        onSubmitted: () {
                                          showSearchWidgets.value = false;
                                          showFinalResults.value = true;
                                          showRecentSearch.value = false;
                                          showChannelDetail.value = false;
                                          showTotalChannel.value = false;
                                        },
                                      );
                                    },
                                    loading: () => CircularLoading(),
                                    error: (error, stackTrace) =>
                                        ErrorMessage(message: '${error}'),
                                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// 슬라이드 애니메이션 함수
  Widget _buildSlideTransition(Widget child, Animation<double> animation) {
    // 뒤로가기 시 애니메이션 방향을 역으로 설정

    // final offset = isBackwards ? Offset(-1.0, 0.0) : Offset(1.0, 0.0);
    // final slideAnimation = Tween<Offset>(begin: offset, end: Offset.zero).animate(animation);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut, // 부드러운 시작과 끝
      ),
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
    // return SlideTransition(
    //   position: slideAnimation,
    //   child: child,
    // );
  }
}
