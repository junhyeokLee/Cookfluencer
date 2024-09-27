import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeSearchScreen extends HookConsumerWidget {
  final String? resultSearch; // 키워드를 받을 수 있는 변수
  HomeSearchScreen({Key? key, this.resultSearch}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(); // TextEditingController 생성
    final searchQuery = useState<String>(resultSearch!); // 검색 쿼리 상태 관리
    final recentSearches = useState<List<String>>([]); // 최근 검색어 상태 관리
    final showSearchWidgets = useState<bool>(false); // 검색 위젯 보이기 여부
    final showFinalResults = useState<bool>(true); // 최종 검색 결과 화면 제어
    // final showRecentSearch = useState<bool>(false); // 최근 검색어 보이기 여부 추가

    final fb_searchResult = ref.watch(autoSearchChannelAndVideoProvider(searchQuery.value));
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    return WillPopScope(
      onWillPop: () {
        if (GoRouter.of(context).canPop()) {
          // pop 대신 go를 사용해 애니메이션을 적용
          searchQuery.value = ''; // 검색 쿼리 초기화
          searchController.clear(); // 검색 컨트롤러 초기화
          GoRouter.of(context).go('/home');
        } else {
          searchQuery.value = ''; // 검색 쿼리 초기화
          searchController.clear(); // 검색 컨트롤러 초기화
          GoRouter.of(context).go('/home');
        }
        return Future.value(false); // 기본적으로 뒤로 가기 막기
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼을 숨김
            title: SearchBarWidget(
              searchQuery: searchQuery,
              searchController: searchController,
              recentSearches: recentSearches,
              onSearchTap: () {
                showSearchWidgets.value = true; // 자동 검색 화면 활성화
                showFinalResults.value = false; // 최종 검색 결과 숨기기
              },
              onBackPressed: () {
                showSearchWidgets.value = true; // 첫 화면 보이기
                showFinalResults.value = false; // 최종 검색 결과 숨기기
                searchQuery.value = ''; // 검색 쿼리 초기화
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
              ? ResultSearch(searchQuery: searchQuery.value)
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
                          searchQuery: searchQuery,
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
          ),
    );
  }
}
