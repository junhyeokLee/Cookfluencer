import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
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
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchScreen extends HookConsumerWidget {
  // final ChannelData? channelData;
  // const SearchScreen({Key? key, this.channelData}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController =
        useTextEditingController(); // TextEditingController 생성
    final searchQuery = useState<String>(''); // 검색 쿼리 상태 관리
    final recentSearches = useState<List<String>>([]); // 최근 검색어 상태 관리
    final showSearchWidgets = useState<bool>(true); // 검색 위젯 보이기 여부
    final showFinalResults = useState<bool>(false); // 최종 검색 결과 화면 제어
    final showRecentSearch = useState<bool>(true); // 최근 검색어 보이기 여부 추가
    final showChannelDetail = useState<bool>(false); // ChannelItem 선택 시 보이기 여부
    final showTotalChannel = useState<bool>(false); // 채널 검색 결과 화면 제어

    final selectedChannelData =
        useState<ChannelData?>(null); // 선택된 채널 데이터 변수 추가
    final selectedTotalChannel = useState<String>(''); // 선택된 전체보기 타이틀 쿼리 변수 추가

    // 파라미터가 필요한 경우를 확인 후 수정
    final fb_searchResult =
        ref.watch(autoSearchChannelAndVideoProvider(searchQuery.value));
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    useEffect(() {
      loadRecentSearches(recentSearches);
      return null; // cleanup 함수가 필요 없는 경우 null 반환
    }, []);

    return WillPopScope(
      onWillPop: () async {
        // ChannelItem 또는 전체보기 페이지가 열렸을 때 뒤로가기 처리
        if (showChannelDetail.value || showTotalChannel.value) {
          showChannelDetail.value = false; // 채널 상세 페이지 숨기기
          showSearchWidgets.value = false; // 검색 화면 유지
          showTotalChannel.value = false; // 채널 전체 화면 숨기기
          showFinalResults.value = true; // 최종 검색 결과 유지
          return false; // 기본 pop 동작 방지
        }
        // 최종 검색 결과 화면이 활성화된 경우
        if (showFinalResults.value || !showSearchWidgets.value) {
          showSearchWidgets.value = true; // 첫 화면 보이기
          showFinalResults.value = false; // 최종 검색 결과 숨기기
          showRecentSearch.value = true; // 최근 검색어 다시 보이기
          searchQuery.value = ''; // 검색 쿼리 초기화
          searchController.clear(); // 검색 컨트롤러 초기화
          return false; // 기본 pop 동작 방지
        }

        searchQuery.value = ''; // 검색 쿼리 초기화
        searchController.clear(); // 검색 컨트롤러 초기화
        return true; // 기본 pop 동작
      },
      child: Scaffold(
        appBar: AppBar(
          title: SearchBarWidget(
            searchQuery: searchQuery,
            // 값으로 전달
            searchController: searchController,
            recentSearches: recentSearches,
            showChannelDetail: showChannelDetail.value,
            // 값으로 전달
            onSearchTap: () {
              showSearchWidgets.value = false; // 자동 검색 화면 활성화
              showFinalResults.value = false; // 최종 검색 결과 숨기기
              showRecentSearch.value = false; // 최근 검색어 숨기기
              showChannelDetail.value = false; // 채널 상세 페이지 숨기기
              showTotalChannel.value = false; // 채널 전체 화면 숨기기
            },
            onBackPressed: () {
              // 채널 상세보기 또는 전체보기 뒤로가기 상태
              if (showChannelDetail.value || showTotalChannel.value) {
                showChannelDetail.value = false; // 채널 상세 페이지 숨기기
                showSearchWidgets.value = false; // 검색 화면 유지
                showFinalResults.value = true; // 최종 검색 결과 유지
                showTotalChannel.value = false; // 채널 전체 화면 숨기기
                return;
              }
              // 뒤로가기 상태
              showSearchWidgets.value = true; // 첫 화면 보이기
              showFinalResults.value = false; // 최종 검색 결과 숨기기
              showRecentSearch.value = true; // 최근 검색어 다시 보이기
              searchQuery.value = ''; // 검색 쿼리 초기화
              searchController.clear(); // 검색 컨트롤러 초기화
            },
            showBackButton: !showSearchWidgets.value,
            // 뒤로가기 버튼 표시 여부
            onSubmitted: () {
              // 검색 완료 시
              showSearchWidgets.value = false; // 자동 검색 화면 숨기기
              showFinalResults.value = true; // 최종 검색 결과 화면 보이기
              showRecentSearch.value = false; // 최근 검색어 숨기기
              showChannelDetail.value = false; // 채널 상세 페이지 숨기기
              showTotalChannel.value = false; // 채널 전체 화면 숨기기
            },
            enabled: true, // ResultSearch가 true일 때 enabled 설정
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500), // 애니메이션 지속 시간 설정
          transitionBuilder: (Widget child, Animation<double> animation) {
            return _buildSlideTransition(child, animation);
          },
          child: showTotalChannel.value
              ? Totalchannels(
                  searchQuery: selectedTotalChannel.value,
                  onChannelItemClick: (channelData) {
                    showTotalChannel.value = false; // 채널 전체 화면 숨기기
                    selectedChannelData.value = channelData; // 선택된 채널 데이터를 저장
                    showChannelDetail.value = true; // 채널 상세 화면 보이기
                  }) // 전체보기 화면
              : showChannelDetail.value
                  ? ResultSearchChannel(
                      key: ValueKey(
                          selectedChannelData.value?.id), // 키를 추가하여 변경 감지
                      channelData: selectedChannelData.value!,
                    ) // ChannelItem 클릭 시 표시할 화면
                  : showFinalResults.value
                      ? ResultSearch(
                          key: ValueKey(searchQuery.value), // 키를 추가하여 변경 감지
                          searchQuery: searchQuery.value,
                          onChannelItemClick: (channelData) {
                            selectedChannelData.value =
                                channelData; // 선택된 채널 데이터를 저장
                            showChannelDetail.value = true; // 채널 상세 화면 보이기
                          },
                          onTotalChannelClick: (String) {
                            selectedTotalChannel.value =
                                String; // 선택된 전체보기 타이틀 쿼리 저장
                            showTotalChannel.value = true; // 채널 전체 화면 보이기
                          },
                        )
                      : showSearchWidgets.value
                          ? Column(
                              key: ValueKey('searchWidgets'), // 키를 추가하여 변경 감지
                              children: [
                                RecentSearch(
                                  recentSearches: recentSearches, // 값으로 전달
                                  searchQuery: searchQuery, // 값으로 전달
                                  searchController: searchController,
                                  onSubmitted: () {
                                    showSearchWidgets.value =
                                        false; // 자동 검색 화면 숨기기
                                    showFinalResults.value =
                                        true; // 최종 검색 결과 화면 보이기
                                    showRecentSearch.value =
                                        false; // 최근 검색어 숨기기
                                    showChannelDetail.value =
                                        false; // 채널 상세 페이지 숨기기
                                    showTotalChannel.value =
                                        false; // 채널 전체 화면 숨기기
                                  },
                                ),
                                keywordListAsyncValue.when(
                                  data: (keywords) {
                                    List<Map<String, dynamic>> keywordList =
                                        keywords
                                            .map((doc) => doc.data()
                                                as Map<String, dynamic>)
                                            .toList();
                                    return Popularkeyword(
                                      keywordList: keywordList,
                                      searchQuery: searchQuery, // 값으로 전달
                                      onSubmitted: () {
                                        showSearchWidgets.value =
                                            false; // 자동 검색 화면 숨기기
                                        showFinalResults.value =
                                            true; // 최종 검색 결과 화면 보이기
                                        showRecentSearch.value =
                                            false; // 최근 검색어 숨기기
                                        showChannelDetail.value =
                                            false; // 채널 상세 페이지 숨기기
                                        showTotalChannel.value =
                                            false; // 채널 전체 화면 숨기기
                                      },
                                      searchController: searchController,
                                    ); // 키워드 리스트 전달
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
                                  // 키를 추가하여 변경 감지
                                  results: results,
                                  searchQuery: searchQuery,
                                  // 값으로 전달
                                  searchController: searchController,
                                  onSubmitted: () {
                                    showSearchWidgets.value =
                                        false; // 자동 검색 화면 숨기기
                                    showFinalResults.value =
                                        true; // 최종 검색 결과 화면 보이기
                                    showRecentSearch.value =
                                        false; // 최근 검색어 숨기기
                                    showChannelDetail.value =
                                        false; // 채널 상세 페이지 숨기기
                                    showTotalChannel.value =
                                        false; // 채널 전체 화면 숨기기
                                  },
                                );
                              },
                              loading: () => CircularLoading(),
                              error: (error, stackTrace) =>
                                  ErrorMessage(message: '${error}'),
                            ),
        ),
      ),
    );
  }
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
