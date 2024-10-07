import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AutoSearch extends StatelessWidget {
  const AutoSearch({
    super.key,
    required this.results,
    required this.searchQuery,
    required this.searchController,
    required this.onSubmitted, // 추가: 엔터를 눌렀을 때 동작
  });

  final List<Map<String, dynamic>> results;
  final ValueNotifier<String> searchQuery;
  final TextEditingController searchController;
  final VoidCallback onSubmitted; // 추가: 엔터를 눌렀을 때 동작

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 16, top: 16, right: 16),
      child: ListView.builder(
        itemCount: results.length,
        itemBuilder: (context, index) {
          final item = results[index];
          return GestureDetector(
            onTap: () {
              // 아이템 클릭 시 검색어를 해당 제목으로 업데이트
              searchQuery.value = item['title'] ?? '';
              searchController.text = item['title']; // 검색어 업데이트
              onSubmitted(); // 추가: 엔터 눌렀을 때 동작 실행
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // 원형으로 설정
                      color: AppColors.greyBackground, // 배경색 설정
                    ),
                    padding: EdgeInsets.all(6), // 아이콘 주위의 패딩 (사이즈 조정)
                    child: Icon(
                      Icons.search,
                      size: 12,
                      color: AppColors.grey,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      item['title'], // 채널 이름 또는 비디오 제목 표시
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelMedium
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}