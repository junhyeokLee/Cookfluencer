import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBarWidget extends HookConsumerWidget {
  const SearchBarWidget({
    super.key,
    required this.searchQuery,
    required this.searchController,
    required this.recentSearches,
    required this.onSearchTap, // 클릭 시 호출될 함수
    required this.onBackPressed, // 뒤로가기 클릭 시 호출될 함수
    required this.showBackButton, // 뒤로가기 아이콘 표시 여부
    required this.onSubmitted, // 엔터를 눌렀을 때 동작 추가
    this.enabled = true, // 텍스트 필드 활성화 여부
    this.showChannelDetail = false, // 인플루언서 텍스트 표시 여부
  });

  final ValueNotifier<String> searchQuery;
  final TextEditingController searchController;
  final ValueNotifier<List<String>> recentSearches;
  final VoidCallback onSearchTap; // 클릭 시 호출될 함수 타입 추가
  final VoidCallback onBackPressed; // 뒤로가기 클릭 시 호출될 함수
  final bool showBackButton; // 뒤로가기 아이콘 표시 여부 추가
  final VoidCallback onSubmitted; // 추가된 콜백
  final bool enabled; // 추가된 텍스트 필드 활성화 여부
  final bool showChannelDetail; // 인플루언서 텍스트 표시 여부 추가

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // searchController.text = searchQuery.value; // 초기값 설정
    searchController.value = searchController.value.copyWith(
      text: searchQuery.value,
      selection: TextSelection.collapsed(offset: searchQuery.value.length),
    );
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: AppColors.grey)), // 밑줄 추가
          ),
          child: Row(
            children: [
              if (showBackButton) // showBackButton에 따라 아이콘 표시
                IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
                  onPressed: () {
                    // searchQuery.value = ''; // 검색어 초기화
                    // searchController.clear(); // TextField 초기화
                    onBackPressed(); // 뒤로가기 아이콘 클릭 시 호출
                  },
                ),
              if (showChannelDetail) // showChannelDetail이 true일 때 검색어 왼쪽에 인플루언서 텍스트 표시
                Container(
                  margin: EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.white, // 텍스트 주변에 배경색 추가
                    borderRadius: BorderRadius.circular(4), // 모서리 둥글게 처리
                    border: Border.all(
                      color: AppColors.greyBackground, // 보더 색상
                      width: 1.0, // 보더 두께
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 6, right: 6, top: 4, bottom: 4),
                    child: Text(
                      '인플루언서',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall
                          ?.copyWith(color: AppColors.black, fontSize: 12),
                    ),
                  ),
                ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: showBackButton ? 0 : 0.0),
                      // 아이콘 유무에 따라 패딩 조정
                      child: searchQuery.value.isEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Text('검색어를 입력하세요',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppColors.grey,
                                      )),
                            )
                          : SizedBox.shrink(), // 힌트가 필요 없을 때는 숨김
                    ),
                    GestureDetector(
                      onTap: enabled ? () {} : null,
                      // enabled가 true일 때만 클릭 이벤트 허용
                      child: AbsorbPointer(
                        // AbsorbPointer를 사용하여 클릭 및 포커스 차단
                        absorbing: !enabled, // enabled가 false일 때 클릭 및 포커스 차단
                        child: TextField(
                          cursorColor: AppColors.grey,
                          cursorWidth: 1,
                          textInputAction: TextInputAction.search,
                          cursorHeight: 20,
                          style: Theme.of(context).textTheme.bodyLarge,
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: '',
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            // 포커스 시 밑줄 없음
                            enabledBorder: InputBorder.none,
                            // 활성화 상태에서도 밑줄 없음
                            disabledBorder: InputBorder.none,
                            // 비활성화 상태에서도 밑줄 없음
                            errorBorder: InputBorder.none,
                            // 에러 상태에서 밑줄 없음
                            suffixIcon: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (searchQuery.value.isNotEmpty)
                                  IconButton(
                                    icon: Icon(Icons.clear,
                                        color: AppColors.grey),
                                    onPressed: () {
                                      searchQuery.value = '';
                                      searchController.clear();
                                      ref.refresh(
                                          autoSearchChannelAndVideoProvider(
                                              ''));
                                    },
                                  ),
                                IconButton(
                                  icon: Icon(Icons.search, color: AppColors.grey),
                                  onPressed: () async {
                                    if (searchQuery.value.isNotEmpty &&
                                        !recentSearches.value.contains(searchQuery.value)) {
                                      // 이미 존재하는 검색어가 아니면 추가
                                      recentSearches.value = [
                                        ...recentSearches.value,
                                        searchQuery.value,
                                      ];
                                      await saveRecentSearches(
                                          recentSearches.value); // 최근 검색어 저장
                                    }
                                    onSubmitted(); // 엔터 눌렀을 때 동작 실행
                                  },
                                ),
                              ],
                            ),
                          ),
                          onTap: onSearchTap,
                          onChanged: (value) {
                            searchQuery.value = value.trim(); // 검색어 상태 업데이트
                            ref.refresh(autoSearchChannelAndVideoProvider(
                                searchQuery.value)); // 검색어 변경 시 검색 결과 업데이트
                          },
                          onSubmitted: (value) async {
                            if (value.isNotEmpty &&
                                !recentSearches.value.contains(value)) {
                              // 이미 존재하는 검색어가 아니면 추가
                              recentSearches.value = [
                                ...recentSearches.value,
                                value,
                              ];
                              await saveRecentSearches(
                                  recentSearches.value); // 최근 검색어 저장
                            }
                            onSubmitted(); // 엔터 눌렀을 때 동작 실행
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
