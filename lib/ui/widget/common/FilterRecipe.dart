import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';

enum FilterOption { latest, viewCount }

class FilterRecipe extends HookWidget {
  final ValueNotifier<FilterOption> selectedFilter;
  final ValueNotifier<bool> showFilterOptions;
  final Function(FilterOption) onFilterChanged;

  const FilterRecipe({
    Key? key,
    required this.selectedFilter,
    required this.showFilterOptions,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            showFilterOptions.value = !showFilterOptions.value;
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                selectedFilter.value == FilterOption.latest ? '최신순' : '인기순',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                showFilterOptions.value
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 16,
              ),
            ],
          ),
        ),
        if (showFilterOptions.value)
          Column(
            children: [
              if (selectedFilter.value != FilterOption.latest)
                GestureDetector(
                  onTap: () {
                    selectedFilter.value = FilterOption.latest;
                    showFilterOptions.value = false;
                    onFilterChanged(FilterOption.latest); // 최신순 선택
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('최신순'),
                  ),
                ),
              if (selectedFilter.value != FilterOption.viewCount)
                GestureDetector(
                  onTap: () {
                    selectedFilter.value = FilterOption.viewCount;
                    showFilterOptions.value = false;
                    onFilterChanged(FilterOption.viewCount); // 인기순 선택
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('인기순'),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}
