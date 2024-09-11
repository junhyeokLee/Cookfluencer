import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> LoadRecentSearches(ValueNotifier<List<String>> recentSearches) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? searches = prefs.getStringList('recentSearches');
  if (searches != null) {
    recentSearches.value = searches; // 최근 검색어 업데이트
    print("Loaded recent searches: $searches"); // 디버깅용 로그
  } else {
    print("No recent searches found."); // 디버깅용 로그
  }
}

Future<void> SaveRecentSearches(List<String> searches) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('recentSearches', searches); // 최근 검색어 저장
  print("Saved recent searches: $searches"); // 디버깅용 로그
}
