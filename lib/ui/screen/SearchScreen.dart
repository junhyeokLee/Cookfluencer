import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/PopularKeyword.dart';
import 'package:cookfluencer/ui/widget/search/RecentSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchAlgoria.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchChannel.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:cookfluencer/ui/widget/search/TotalChannels.dart';
import 'package:flutter/cupertino.dart';
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

    // 키보드 닫는 기능 추가
    void _dismissKeyboard() {
      FocusScope.of(context).unfocus();
    }

    // 검색 결과를 가져오는 프로바이더
    final fb_searchResult = ref.watch(autoSearchChannelAndVideoProvider(searchQuery.value));
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    // 최근 검색어 로드
    useEffect(() {
      loadRecentSearches(recentSearches);
      return null;
    }, []);

    return GestureDetector(
      onTap: _dismissKeyboard, // 화면 터치 시 키보드 닫기
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(toolbarHeight: 0),
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
                showBackButton: false,
                enabled: true,
                showChannelDetail: false,
                onSearchTap: () {
                  searchQuery.value = searchController.text; // 검색어 업데이트
                  showSearchWidgets.value = false;
                  showRecentSearch.value = false;
                  showFinalResults.value = false;
                  searchQuery.value = "";
                  searchController.clear();
                  },
                onSubmitted: () {
                  _navigateToResultsPage(context, searchQuery.value); // 결과 페이지로 이동
                  showSearchWidgets.value = false;
                  showRecentSearch.value = true;
                  showFinalResults.value = false;
                  searchQuery.value = "";
                  searchController.clear();
                }, onBackPressed: () {

              },
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return _buildSlideTransition(child, animation);
                  },
                  child: searchQuery.value.isEmpty
                      ? Column(
                    key: ValueKey('searchWidgets'),
                    children: [
                      RecentSearch(
                        recentSearches: recentSearches,
                        searchQuery: searchQuery,
                        searchController: searchController,
                        onSubmitted: () {
                          showSearchWidgets.value = true;
                          showFinalResults.value = false;
                          showRecentSearch.value = false;
                          showChannelDetail.value = false;
                          showTotalChannel.value = false;
                          _navigateToResultsPage(context, searchQuery.value);
                          searchQuery.value = "";
                          searchController.clear();
                        },
                      ),
                      keywordListAsyncValue.when(
                        data: (keywords) {
                          List<Map<String, dynamic>> keywordList = keywords
                              .map((doc) => doc.data() as Map<String, dynamic>)
                              .toList();
                          return Popularkeyword(
                            keywordList: keywordList,
                            searchQuery: searchQuery,
                            onSubmitted: () {
                              showSearchWidgets.value = true;
                              showFinalResults.value = false;
                              showRecentSearch.value = false;
                              showChannelDetail.value = false;
                              showTotalChannel.value = false;
                              _navigateToResultsPage(context, searchQuery.value);
                              searchQuery.value = "";
                              searchController.clear();
                            },
                            searchController: searchController,
                          );
                        },
                        loading: () => CircularLoading(),
                        error: (error, stackTrace) => ErrorMessage(message: '${error}'),
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
                          showSearchWidgets.value = true;
                          showFinalResults.value = false;
                          showRecentSearch.value = false;
                          showChannelDetail.value = false;
                          showTotalChannel.value = false;
                          _navigateToResultsPage(context, searchQuery.value);
                          searchQuery.value = "";
                          searchController.clear();
                        },
                      );
                    },
                    loading: () => CircularLoading(),
                    error: (error, stackTrace) => ErrorMessage(message: '${error}'),
                  ),
                ),
              ),
            ],
          ),
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
  }

// 결과 페이지로 이동하는 메서드 (슬라이드 애니메이션 추가)
  void _navigateToResultsPage(BuildContext context, String searchQuery) {
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (context) => ResultSearchAlgoria(
          searchQuery: searchQuery,
          onChannelItemClick: (channelData) {
            // 채널 클릭 시 채널 상세 페이지로 이동
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => ResultSearchChannel(
                  channelData: channelData,
                ),
              ),
            );
          },
          onTotalChannelClick: (String totalChannel) {
            // 전체 채널 클릭 시 TotalChannels 페이지로 이동
            Navigator.of(context).push(
              CupertinoPageRoute(
                builder: (context) => Totalchannels(
                  searchQuery: totalChannel,
                  onChannelItemClick: (channelData) {
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => ResultSearchChannel(
                          channelData: channelData,
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

}