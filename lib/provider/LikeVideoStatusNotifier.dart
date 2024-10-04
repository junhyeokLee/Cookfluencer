import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookfluencer/data/channelData.dart';

// LikeStatus 객체 정의
class LikeVideoStatus {
  final String id;
  final String channelId;
  final String channelName;
  final String description;
  final String thumbnailUrl;
  final String title;
  final String uploadDate;
  final String videoId;
  final String videoUrl;
  final int viewCount;
  final String section;
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
    required this.isLiked,
  });
}

// LikeStatusNotifier 정의
class LikeVideoStatusNotifier extends StateNotifier<Map<String, LikeVideoStatus>> {
  LikeVideoStatusNotifier() : super({}) {
    _loadLikedVideos(); // 앱 시작 시 좋아요된 채널 로드
  }

  // 저장된 좋아요 상태를 로드하는 메소드
  Future<void> _loadLikedVideos() async {
    final likedVideos = await loadLikedVideoData(); // 기기에서 좋아요된 채널 불러오기

    // 각 채널의 좋아요 상태를 업데이트
    for (VideoData videoData in likedVideos) {
      state[videoData.id] = LikeVideoStatus(
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
        isLiked: true,
      );
    }
  }

  void toggleLike(VideoData videoData) async {
    final isLiked = state[videoData.videoId]?.isLiked ?? false;

    // 상태 업데이트
    state = {
      ...state,
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
        isLiked: !isLiked, // 좋아요 상태 반전
      )
    };

    // 기기에 저장 또는 삭제
    if (!isLiked) {
      await saveVideoData(videoData); // 좋아요 추가 시 저장
    } else {
      await removeVideoData(videoData.videoId); // 좋아요 해제 시 삭제
    }

    // 상태 변경 후 UI 갱신
    state = {...state};  // 강제로 상태를 다시 설정하여 UI가 업데이트되도록 함

  }
}

// LikeStatusNotifier Provider 정의
  final likeVideoStatusProvider = StateNotifierProvider<LikeVideoStatusNotifier,
      Map<String, LikeVideoStatus>>((ref) {
    return LikeVideoStatusNotifier();
  });

