import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // useState를 사용하기 위해 추가

class Popularkeyword extends HookConsumerWidget {
  const Popularkeyword({
    super.key,
    required this.keywordList,
    required this.searchQuery,
    required this.searchController,
    required this.onSubmitted, // 추가: 엔터를 눌렀을 때 동작
  });

  final List<Map<String, dynamic>> keywordList; // 키워드 리스트
  final VoidCallback onSubmitted; // 추가: 엔터를 눌렀을 때 동작
  final ValueNotifier<String> searchQuery;
  final TextEditingController searchController; // 검색 컨트롤러

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scrollController = useScrollController(); // 스크롤 컨트롤러 추가

    if (keywordList.isEmpty) {
      return const Text('키워드가 없습니다.');
    }

    return SingleChildScrollView( // 전체 스크롤 가능하도록 SingleChildScrollView 사용
      controller: scrollController, // 스크롤 컨트롤러 설정
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 24, top: 24, bottom: 12),
            child: Text('인기 키워드', style: Theme.of(context).textTheme.titleSmall),
          ),
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical, // 세로 스크롤
            itemCount: keywordList.length,
            itemBuilder: (context, index) {
              final keyword = keywordList[index];

              return GestureDetector(
                onTap: () {
                  // 검색어를 클릭한 키워드로 업데이트
                  final selectedKeyword = (keyword['name'] ?? '').trim(); // 공백 제거
                  searchQuery.value = selectedKeyword; // 공백 제거 후 업데이트
                  searchController.text = selectedKeyword; // 공백 제거 후 업데이트
                  onSubmitted(); // 추가: 엔터 눌렀을 때 동작 실행
                },
                child: Container(
                  margin: const EdgeInsets.only(left: 12, bottom: 12), // 간격 조정
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12), // 내부 패딩
                    child: Center(
                      child: Row(
                        children: [
                          Text(
                              "${index + 1}", // 순위 표시
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.w700, // 글자 굵기
                              )
                          ),
                          SizedBox(width: 12),
                          Text(
                              keyword['name'] ?? '', // null 체크 후 텍스트 표시
                              maxLines: 1, // 한 줄로 제한
                              overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                              style: Theme.of(context).textTheme.bodySmall
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}