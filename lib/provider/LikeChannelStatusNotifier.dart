import 'package:cookfluencer/data/videoData.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LikeChannelStatus {
  final String id;
  final String channelName;
  final String channelDescription;
  final String channelUrl;
  final String thumbnailUrl;
  final int subscriberCount;
  final int videoCount;
  final List<VideoData> videos;
  final String section;
  final bool isLiked;

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

class LikeChannelStatusNotifier extends StateNotifier<AsyncValue<Map<String, LikeChannelStatus>>> {
  LikeChannelStatusNotifier() : super(const AsyncLoading()) {
    fetchLikedChannels();
  }

  Future<void> fetchLikedChannels() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        state = const AsyncData({});
        return;
      }

      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('likedChannels')
          .orderBy('createdAt', descending: true)
          .get();

      final liked = <String, LikeChannelStatus>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        liked[doc.id] = LikeChannelStatus(
          id: doc.id,
          channelName: data['channel_name'] ?? '',
          channelDescription: data['channel_description'],
          channelUrl: data['channel_url'] ?? '',
          thumbnailUrl: data['thumbnail_url'] ?? '',
          subscriberCount: data['subscriber_count'] ?? 0,
          videoCount: data['video_count'] ?? 0,
          videos: [],
          section: '',
          isLiked: true,
        );
      }

      state = AsyncData(liked);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  void toggleLike(ChannelData channel) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('likedChannels')
        .doc(channel.id);

    final isLiked = state.value?[channel.id]?.isLiked ?? false;

    if (isLiked) {
      await docRef.delete();
    } else {
      await docRef.set({
        'channel_name': channel.channelName,
        'channel_url': channel.channelUrl,
        'thumbnail_url': channel.thumbnailUrl,
        'channel_description': channel.channelDescription,
        'id': channel.id,
        'subscriber_count': channel.subscriberCount,
        'video_count': channel.videoCount,
        'subscriber_count': channel.subscriberCount,
        'videos':channel.videos,
        'createdAt': DateTime.now().toIso8601String(),
      });
    }

    await fetchLikedChannels();
  }
}

final likeChannelStatusProvider = StateNotifierProvider<LikeChannelStatusNotifier, AsyncValue<Map<String, LikeChannelStatus>>>(
      (ref) => LikeChannelStatusNotifier(),
);
