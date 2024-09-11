import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecentSearch extends HookConsumerWidget {
  const RecentSearch({
    super.key,
    required this.recentSearches,
    required this.searchQuery,
    required this.searchController,
    required this.onSubmitted, // 추가: 엔터를 눌렀을 때 동작
  });

  final ValueNotifier<List<String>> recentSearches;
  final ValueNotifier<String> searchQuery;
  final TextEditingController searchController;
  final VoidCallback onSubmitted; // 추가: 엔터를 눌렀을 때 동작

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 최근 검색어 리스트가 비어있으면 빈 공간을 반환
    if (recentSearches.value.isEmpty) {
      return SizedBox.shrink(); // 아무것도 렌더링하지 않음
    }
    return Column(
      children: [
        // 최근 검색어 텍스트
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // 양 끝 정렬
            children: [
              Text('최근 검색어', style: Theme.of(context).textTheme.labelLarge),
              InkWell(
                onTap: () {
                  // 전체 삭제 기능
                  recentSearches.value = [];
                  SaveRecentSearches(recentSearches.value); // 삭제 후 저장
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Text('전체삭제',
                      style: TextStyle(color: AppColors.grey, fontSize: 12)),
                ),
              ),
            ],
          ),
        ),
        // 최근 검색어 리스트
        Container(
          margin: const EdgeInsets.only(left: 24, top: 12),
          height: 36, // 리스트의 높이 설정
          child: ListView.builder(
            scrollDirection: Axis.horizontal, // 가로 스크롤
            itemCount: recentSearches.value.length,
            itemBuilder: (context, index) {
              final reversedIndex = recentSearches.value.length - 1 - index; // 역순으로 인덱스 계산
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        // 최근 검색어를 클릭했을 때 검색창에 채우기
                        final selectedSearch = recentSearches.value[reversedIndex];
                        searchQuery.value = selectedSearch; // 역순으로 검색어 할당
                        searchController.text = selectedSearch; // 검색창에 텍스트 채우기
                        ref.refresh(searchChannelProvider(selectedSearch)); // 검색어 변경 시 검색 결과 업데이트
                        onSubmitted(); // 추가: 엔터 눌렀을 때 동작 실행
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.greyBackground),
                          // 테두리 추가
                          color: Colors.white,
                          // 선택되면 배경색 변경
                          borderRadius: BorderRadius.circular(8), // 둥근 사각형 (양옆과 위아래가 둥근 형태)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Row의 크기를 내용물에 맞게 설정
                          mainAxisAlignment: MainAxisAlignment.center, // 가로 방향으로 중앙 정렬
                          crossAxisAlignment: CrossAxisAlignment.center, // 세로 방향으로 중앙 정렬
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 6.0, right: 6.0, top: 4.0, bottom: 4.0),
                              child: Text(recentSearches.value[reversedIndex], style: TextStyle(color: AppColors.grey, fontSize: 14)), // 역순으로 텍스트 표시
                            ),
                            GestureDetector(
                              onTap: () {
                                // 검색어 삭제 기능
                                final updatedSearches = List<String>.from(recentSearches.value); // 기존 리스트 복사
                                updatedSearches.removeAt(reversedIndex); // 역순으로 리스트에서 검색어 제거
                                recentSearches.value = updatedSearches; // 변경된 리스트 할당하여 상태 업데이트
                                SaveRecentSearches(updatedSearches); // 변경된 리스트 저장
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(left: 4.0, right: 4.0), // 텍스트와 아이콘 사이 간격 조정
                                child: Icon(Icons.clear, color: AppColors.grey, size: 14), // X 아이콘
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}