// filter_widget.dart
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

enum FilterOption { viewCount, latest } // 필터링 옵션을 위한 enum 정의

class FilterRecipe extends HookWidget {
  final ValueNotifier<FilterOption> selectedFilter; // 선택된 필터 상태
  final ValueNotifier<bool> showFilterOptions; // 필터 옵션을 표시할지 여부

  const FilterRecipe({
    Key? key,
    required this.selectedFilter,
    required this.showFilterOptions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            showFilterOptions.value = !showFilterOptions.value; // 필터 옵션 토글
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Text(
                  selectedFilter.value == FilterOption.viewCount
                      ? '인기순'
                      : '최신순',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.end,
                ),
              ),
              Icon(
                size: 16,
                showFilterOptions.value ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                color: Colors.black,
              ),
            ],
          ),
        ),
        if (showFilterOptions.value)
          Padding(
            padding: const EdgeInsets.only(bottom: 12, top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (selectedFilter.value != FilterOption.viewCount)
                  GestureDetector(
                    onTap: () {
                      selectedFilter.value = FilterOption.viewCount; // 조회순 선택
                      showFilterOptions.value = false; // 옵션 닫기
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '인기순',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                if (selectedFilter.value != FilterOption.latest)
                  GestureDetector(
                    onTap: () {
                      selectedFilter.value = FilterOption.latest; // 최신순 선택
                      showFilterOptions.value = false; // 옵션 닫기
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.greyBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '최신순',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}