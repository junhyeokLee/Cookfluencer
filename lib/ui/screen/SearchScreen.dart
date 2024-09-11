import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/dart/extension/context_extension.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/PopularKeyword.dart';
import 'package:cookfluencer/ui/widget/search/RecentSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart'; // SharedPreferences 패키지 추가

class SearchScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(); // TextEditingController 생성
    final searchQuery = useState<String>(''); // 검색 쿼리 상태 관리
    final recentSearches = useState<List<String>>([]); // 최근 검색어 상태 관리
    final showSearchWidgets = useState<bool>(true); // 검색 위젯 보이기 여부
    final showFinalResults = useState<bool>(false); // 최종 검색 결과 화면 제어
    final showRecentSearch = useState<bool>(true); // 최근 검색어 보이기 여부 추가

    final fb_searchResult = ref.watch(searchChannelProvider(searchQuery.value));
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    useEffect(() {
      LoadRecentSearches(recentSearches);
      return null; // cleanup 함수가 필요 없는 경우 null 반환
    }, []);

    return WillPopScope(
      onWillPop: () async {
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
            searchController: searchController,
            recentSearches: recentSearches,
            onSearchTap: () {
              showSearchWidgets.value = false; // 자동 검색 화면 활성화
              showFinalResults.value = false; // 최종 검색 결과 숨기기
              showRecentSearch.value = false; // 최근 검색어 숨기기
            },
            onBackPressed: () {
              showSearchWidgets.value = true; // 첫 화면 보이기
              showFinalResults.value = false; // 최종 검색 결과 숨기기
              showRecentSearch.value = true; // 최근 검색어 다시 보이기
              searchQuery.value = ''; // 검색 쿼리 초기화
              searchController.clear(); // 검색 컨트롤러 초기화
            },
            showBackButton: !showSearchWidgets.value, // 뒤로가기 버튼 표시 여부
            onSubmitted: () {
              // 검색 완료 시
              showSearchWidgets.value = false; // 자동 검색 화면 숨기기
              showFinalResults.value = true; // 최종 검색 결과 화면 보이기
              showRecentSearch.value = false; // 최근 검색어 숨기기
            },
            enabled: !showFinalResults.value, // showFinalResults가 true일 때 비활성화
          ),
        ),
        body: showFinalResults.value
            ? ResultSearch(searchQuery: searchQuery.value) // showFinalResults가 true일 때 표시할 화면
            : showSearchWidgets.value
            ? Column(
          children: [
            RecentSearch(
              recentSearches: recentSearches,
              searchQuery: searchQuery,
              searchController: searchController,
              onSubmitted: () {
                showSearchWidgets.value = false; // 자동 검색 화면 숨기기
                showFinalResults.value = true; // 최종 검색 결과 화면 보이기
                showRecentSearch.value = false; // 최근 검색어 숨기기
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
                    // 엔터 누르기 동작을 처리
                    showSearchWidgets.value = false; // 자동 검색 화면 숨기기
                    showFinalResults.value = true; // 최종 검색 결과 화면 보이기
                    showRecentSearch.value = false; // 최근 검색어 숨기기
                  },
                  searchController: searchController, // 검색 컨트롤러 전달
                ); // 키워드 리스트 전달
              },
              loading: () => Center(
                child: CircularProgressIndicator(
                  color: AppColors.greyBackground,
                ),
              ),
              error: (error, stackTrace) => Center(
                child: Text('키워드 로드 중 오류 발생: $error'),
              ),
            ),
          ],
        )
            : fb_searchResult.when(
          data: (results) {
            // 검색 결과가 있는 경우
            if (results.isEmpty) {
              return Center(
                child: Text('검색 결과가 없습니다.'), // 결과가 없을 때 메시지
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
                showRecentSearch.value = false; // 최근 검색어 숨기기
              },
            ); // 검색 결과 위젯 반환
          },
          loading: () => Center(
            child: CircularProgressIndicator(
              color: AppColors.greyBackground,
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text('검색 중 오류 발생: $error'),
          ),
        ),
      ),
    );
  }
}