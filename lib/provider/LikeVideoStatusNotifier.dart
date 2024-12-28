import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookfluencer/data/channelData.dart';

// LikeStatus 객체 정의
class LikeVideoStatus {
  final String id; // 비디오 ID
  final String channelId; // 채널 ID
  final String channelName; // 채널 이름
  final String description; // 비디오 설명
  final String thumbnailUrl; // 비디오 썸네일 URL
  final String title; // 비디오 제목
  final String uploadDate; // 비디오 업로드 날짜
  final String videoId; // 비디오 ID (중복 사용)
  final String videoUrl; // 비디오 URL
  final int viewCount; // 비디오 조회수
  final String section; // 비디오 섹션
  final RecipeData recipe; // 비디오 레시피
  final bool isLiked; // 좋아요 여부

  LikeVideoStatus({
    required this.id,
    required this.channelId,
    required this.channelName,
    required this.description,
    required this.thumbnailUrl,
    required this.title,
    required this.uploadDate,
    required this.videoId,
    required this.videoUrl,
    required this.viewCount,
    required this.section,
    required this.recipe,
    required this.isLiked,
  });
}

// LikeStatusNotifier 정의
class LikeVideoStatusNotifier extends StateNotifier<AsyncValue<Map<String, LikeVideoStatus>>> {
  LikeVideoStatusNotifier() : super(AsyncValue.loading()) {
    _loadLikedVideos(); // 앱 시작 시 좋아요된 비디오 로드
  }

  // 비디오 데이터를 로드하는 메소드
  Future<void> _loadLikedVideos() async {
    try {
      final likedVideos = await loadLikedVideoData(); // 기기에서 좋아요된 비디오 불러오기
      Map<String, LikeVideoStatus> loadedVideos = {};

      for (VideoData videoData in likedVideos) {
        loadedVideos[videoData.videoId] = LikeVideoStatus(
          id: videoData.id,
          channelId: videoData.channelId,
          channelName: videoData.channelName,
          description: videoData.description,
          thumbnailUrl: videoData.thumbnailUrl,
          title: videoData.title,
          uploadDate: videoData.uploadDate,
          videoId: videoData.videoId,
          videoUrl: videoData.videoUrl,
          viewCount: videoData.viewCount,
          section: videoData.section,
          recipe: videoData.recipe == null ? RecipeData() : videoData.recipe!,
          isLiked: true,
        );
      }
      state = AsyncValue.data(loadedVideos);
    } catch (e) {
      state = AsyncValue.error(e,StackTrace.current); // 에러 발생 시 상태 변경
    }
  }

  // 비디오 좋아요/싫어요 토글 메소드
  void toggleLike(VideoData videoData) async {
    final currentState = state;

    if (currentState is AsyncData) {
      final currentStatus = currentState.value?[videoData.videoId];
      bool newIsLiked = !(currentStatus?.isLiked ?? false);

      // 상태 업데이트
      final updatedVideos = {
        ...?currentState.value,
        videoData.videoId: LikeVideoStatus(
          id: videoData.id,
          channelId: videoData.channelId,
          channelName: videoData.channelName,
          description: videoData.description,
          thumbnailUrl: videoData.thumbnailUrl,
          title: videoData.title,
          uploadDate: videoData.uploadDate,
          videoId: videoData.videoId,
          videoUrl: videoData.videoUrl,
          viewCount: videoData.viewCount,
          section: videoData.section,
          recipe: videoData.recipe == null ? RecipeData() : videoData.recipe!,
          isLiked: newIsLiked, // 좋아요 상태 반전
        ),
      };

      state = AsyncValue.data(updatedVideos); // 상태 업데이트

      // 기기에 저장 또는 삭제
      if (newIsLiked) {
        await saveVideoData(videoData); // 좋아요 추가 시 저장
      } else {
        await removeVideoData(videoData.videoId); // 좋아요 해제 시 삭제
      }
    }
  }
}

// LikeStatusNotifier Provider 정의
final likeVideoStatusProvider = StateNotifierProvider<LikeVideoStatusNotifier,
    AsyncValue<Map<String, LikeVideoStatus>>>((ref) {
  return LikeVideoStatusNotifier();
});
