
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final RecipeData recipe;
  final bool isLiked;

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

class LikeVideoStatusNotifier extends StateNotifier<AsyncValue<Map<String, LikeVideoStatus>>> {
  LikeVideoStatusNotifier() : super(const AsyncLoading()) {
    fetchLikedVideos();
  }

  Future<void> fetchLikedVideos() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AsyncData({});
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('likedVideos')
          .orderBy('createdAt', descending: true)
          .get();

      final liked = <String, LikeVideoStatus>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();

        final fallbackId = doc.id; // 문서 ID를 video_id로 사용

        liked[doc.id] = LikeVideoStatus(
          id: fallbackId,
          channelId: data['channel_id'] ?? '',
          channelName: data['channel_name'] ?? '',
          description: data['description'] ?? '',
          thumbnailUrl: data['thumbnail_url'] ?? '',
          title: data['title'] ?? '',
          uploadDate: data['upload_date'] ?? '',
          videoId: data['video_id'] ?? fallbackId, // 🛡fallback 적용
          videoUrl: data['video_url'] ?? '',
          viewCount: data['view_count'] ?? 0,
          section: data['section'] ?? '',
          recipe: RecipeData(),
          isLiked: true,
        );
      }

      state = AsyncData(liked);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }


  void toggleLike(VideoData video) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('likedVideos')
        .doc(video.videoId);

    final isLiked = state.value?[video.videoId]?.isLiked ?? false;

    if (isLiked) {
      await docRef.delete();
    } else {
      await docRef.set({
        'video_id': video.videoId,
        'title': video.title,
        'thumbnail_url': video.thumbnailUrl,
        'channel_id': video.channelId,
        'channel_name': video.channelName,
        'video_url': video.videoUrl,
        'view_count': video.viewCount,
        'upload_date': video.uploadDate,
        'description': video.description,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    // 상태 재요청
    await fetchLikedVideos();
  }

}

final likeVideoStatusProvider = StateNotifierProvider<LikeVideoStatusNotifier, AsyncValue<Map<String, LikeVideoStatus>>>(
      (ref) => LikeVideoStatusNotifier(),
);
