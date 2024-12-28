import 'dart:convert';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
Future<List<ChannelData>> loadLikedChannelData() async {
  final prefs = await SharedPreferences.getInstance();
  final likedChannelsJson = prefs.getStringList('likedChannels') ?? [];

  // JSON 데이터를 ChannelData 객체로 변환
  return likedChannelsJson.map((json) {
    // JSON 문자열을 Map으로 변환 후 ChannelData 객체로 변환
    return ChannelData.fromJson(jsonDecode(json));
  }).toList();
}

// 기기에서 좋아요된 비디오 불러오기
Future<List<VideoData>> loadLikedVideoData() async {
  final prefs = await SharedPreferences.getInstance();
  final likedVideosJson = prefs.getStringList('likedVideos') ?? [];

  // JSON 데이터를 ChannelData 객체로 변환
  return likedVideosJson.map((json) {
    // JSON 문자열을 Map으로 변환 후 ChannelData 객체로 변환
    return VideoData.fromJson(jsonDecode(json));
  }).toList();
}


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
  }
}

// 좋아요된 채널 저장
Future<void> saveVideoData(VideoData videoData) async {
  final prefs = await SharedPreferences.getInstance();
  final likedVideosJson = prefs.getStringList('likedVideos') ?? [];

  // 채널 데이터를 JSON으로 변환
  final videosDataJson = jsonEncode(videoData.toJson());

  // 이미 저장된 채널이 아닌 경우에만 추가
  if (!likedVideosJson.contains(videosDataJson)) {
    likedVideosJson.add(videosDataJson);
    await prefs.setStringList('likedVideos', likedVideosJson);
  }
}

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

Future<void> removeVideoData(String videoId) async {
  final prefs = await SharedPreferences.getInstance();
  final likedVideosJson = prefs.getStringList('likedVideos') ?? [];

  // 해당 채널 ID에 맞는 JSON 데이터를 제거
  final updatedVideosJson = likedVideosJson.where((json) {
    final videoData = VideoData.fromJson(jsonDecode(json));
    return videoData.id != videoId;
  }).toList();
  await prefs.setStringList('likedVideos', updatedVideosJson);
}