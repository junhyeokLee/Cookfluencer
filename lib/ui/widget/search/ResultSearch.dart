import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ResultSearch extends HookConsumerWidget {
  final String searchQuery; // 검색어를 받을 필드

  const ResultSearch({
    super.key,
    required this.searchQuery, // 검색어를 인자로 받음
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // 전달받은 검색어 출력
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            '검색어: $searchQuery', // 검색어 출력
            style: TextStyle(fontSize: 20, color: AppColors.black),
          ),
        ),
      ],
    );
  }
}