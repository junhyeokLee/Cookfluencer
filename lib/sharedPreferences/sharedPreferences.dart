import 'dart:convert';
import 'package:cookfluencer/data/channelData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../provider/LikeStatusNotifier.dart';

// 최근 검색어를 불러오는 함수
Future<void> loadRecentSearches(ValueNotifier<List<String>> recentSearches) async {
  final prefs = await SharedPreferences.getInstance();
  final List<String>? searches = prefs.getStringList('recentSearches');

  // 최근 검색어가 있을 경우 업데이트
  if (searches != null) {
    recentSearches.value = searches;
    print("Loaded recent searches: $searches");
  } else {
    print("No recent searches found.");
  }
}

// 최근 검색어를 저장하는 함수
Future<void> saveRecentSearches(List<String> searches) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setStringList('recentSearches', searches);
  print("Saved recent searches: $searches");
}


// 기기에서 좋아요된 채널 불러오기
// Future<List<String>> loadLikedChannelData() async {
//   final prefs = await SharedPreferences.getInstance();
//   return prefs.getStringList('likedChannels') ?? [];
// }

// 기기에서 좋아요된 채널 불러오기
Future<List<ChannelData>> loadLikedChannelData() async {
  final prefs = await SharedPreferences.getInstance();
  final likedChannelsJson = prefs.getStringList('likedChannels') ?? [];

  debugPrint("불러오기 : $likedChannelsJson");

  // JSON 데이터를 ChannelData 객체로 변환
  return likedChannelsJson.map((json) {
    // JSON 문자열을 Map으로 변환 후 ChannelData 객체로 변환
    return ChannelData.fromJson(jsonDecode(json));
  }).toList();
}


// 좋아요된 채널 저장
// Future<void> saveChannelData(ChannelData channelData) async {
//   final prefs = await SharedPreferences.getInstance();
//   final likedChannels = prefs.getStringList('likedChannels') ?? [];
//
//   if (!likedChannels.contains(channelData.id)) {
//     likedChannels.add(channelData.id);
//     await prefs.setStringList('likedChannels', likedChannels);
//     print("Saved channel ${channelData.id} to liked channels.");
//   }
// }

// 좋아요된 채널 저장
Future<void> saveChannelData(ChannelData channelData) async {
  final prefs = await SharedPreferences.getInstance();
  final likedChannelsJson = prefs.getStringList('likedChannels') ?? [];

  // 채널 데이터를 JSON으로 변환
  final channelDataJson = jsonEncode(channelData.toJson());

  // 이미 저장된 채널이 아닌 경우에만 추가
  if (!likedChannelsJson.contains(channelDataJson)) {
    likedChannelsJson.add(channelDataJson);
    await prefs.setStringList('likedChannels', likedChannelsJson);
    print("채널 저장 : ${channelData} ");
  }
}

// Future<void> removeChannelData(String channelId) async {
//   final prefs = await SharedPreferences.getInstance();
//   final likedChannels = prefs.getStringList('likedChannels') ?? [];
//
//   if (likedChannels.remove(channelId)) {
//     await prefs.setStringList('likedChannels', likedChannels);
//     print("Removed channel $channelId from liked channels.");
//   }
// }

Future<void> removeChannelData(String channelId) async {
  final prefs = await SharedPreferences.getInstance();
  final likedChannelsJson = prefs.getStringList('likedChannels') ?? [];

  // 해당 채널 ID에 맞는 JSON 데이터를 제거
  final updatedChannelsJson = likedChannelsJson.where((json) {
    final channelData = ChannelData.fromJson(jsonDecode(json));
    return channelData.id != channelId;
  }).toList();

  await prefs.setStringList('likedChannels', updatedChannelsJson);
  print("채널 삭제 : $updatedChannelsJson ");
}