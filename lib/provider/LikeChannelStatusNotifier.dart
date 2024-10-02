import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cookfluencer/data/channelData.dart';

// LikeStatus 객체 정의
class LikeChannelStatus {
  final String id; // 채널 ID
  final String channelName; // 채널 이름
  final String channelDescription; // 채널 설명
  final String channelUrl; // 채널 URL
  final String thumbnailUrl; // 썸네일 URL
  final int subscriberCount; // 구독자 수
  final int videoCount; // 비디오 수
  final List<VideoData> videos; // 비디오 리스트
  final String section; // 섹션
  final bool isLiked; // 좋아요 여부

  LikeChannelStatus({
    required this.id,
    required this.channelName,
    required this.channelDescription,
    required this.channelUrl,
    required this.thumbnailUrl,
    required this.subscriberCount,
    required this.videoCount,
    required this.videos,
    required this.section,
    required this.isLiked,
  });
}

// LikeStatusNotifier 정의
class LikeChannelStatusNotifier extends StateNotifier<Map<String, LikeChannelStatus>> {
  LikeChannelStatusNotifier() : super({}) {
    _loadLikedChannels(); // 앱 시작 시 좋아요된 채널 로드
  }

  // 저장된 좋아요 상태를 로드하는 메소드
  Future<void> _loadLikedChannels() async {
    final likedChannels = await loadLikedChannelData(); // 기기에서 좋아요된 채널 불러오기

    // 각 채널의 좋아요 상태를 업데이트
    for (ChannelData channelData in likedChannels) {
      state[channelData.id] = LikeChannelStatus(
        id: channelData.id,
        channelName: channelData.channelName,
        channelDescription: channelData.channelDescription,
        channelUrl: channelData.channelUrl,
        thumbnailUrl: channelData.thumbnailUrl,
        subscriberCount: channelData.subscriberCount,
        videoCount: channelData.videoCount,
        videos: channelData.videos,
        section: channelData.section,
        isLiked: true,
      );
    }
  }

  void toggleLike(ChannelData channelData) async {
    final isLiked = state[channelData.id]?.isLiked ?? false;

    // 상태 업데이트
    state = {
      ...state,
      channelData.id: LikeChannelStatus(
        id: channelData.id,
        channelName: channelData.channelName,
        channelDescription: channelData.channelDescription,
        channelUrl: channelData.channelUrl,
        thumbnailUrl: channelData.thumbnailUrl,
        subscriberCount: channelData.subscriberCount,
        videoCount: channelData.videoCount,
        videos: channelData.videos,
        section: channelData.section,
        isLiked: !isLiked, // 좋아요 상태 반전
      )
    };

    // 기기에 저장 또는 삭제
    if (!isLiked) {
      await saveChannelData(channelData); // 좋아요 추가 시 저장
    } else {
      await removeChannelData(channelData.id); // 좋아요 해제 시 삭제
    }

    // 상태 변경 후 UI 갱신
    state = {...state};  // 강제로 상태를 다시 설정하여 UI가 업데이트되도록 함

  }
}

// LikeStatusNotifier Provider 정의
  final likeChannelStatusProvider = StateNotifierProvider<LikeChannelStatusNotifier,
      Map<String, LikeChannelStatus>>((ref) {
    return LikeChannelStatusNotifier();
  });

