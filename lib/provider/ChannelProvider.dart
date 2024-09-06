import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 채널 리스트를 비동기로 가져오는 프로바이더
final channelListProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance.collection('channels').snapshots();
});

// 추천 채널 리스트를 가져오는 Provider
final recommendChannelsProvider = FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('section', isEqualTo: 'recommend') // "recommend" 섹션의 영상만 가져옴
      .orderBy('subscriber_count', descending: true) // 구독자 수 내림차순으로 정렬
      .get();

  return querySnapshot.docs;
});

// 추천 레시피 리스트를 가져오는 Provider
final recommendVideosProvider = FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('section', isEqualTo: 'recommend') // "recommend" 섹션의 영상만 가져옴
      .get();

  return querySnapshot.docs;
});

// 채널의 추천 영상 가져오기
final channelVideosProvider = FutureProvider.autoDispose.family<List<QueryDocumentSnapshot>, String>((ref, channelId) async {
  // Firestore에서 videos 컬렉션의 데이터를 가져옴
  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .doc(channelId)
      .collection('videos')
      .orderBy('likes', descending: true) // likes를 기준으로 내림차순 정렬
      .orderBy('view_count', descending: true) // view_count를 기준으로 내림차순 정렬
      .limit(3) // 최대 3개만 가져옴
      .get();

  // 가져온 데이터를 리스트로 변환
  return querySnapshot.docs; // 비디오 리스트 반환
});

// Firestore에서 채널 데이터를 검색하는 Provider
final searchChannelProvider = FutureProvider.autoDispose.family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환
  if (searchQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: searchQuery)
      .where('channel_name', isLessThanOrEqualTo: searchQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
      .get();

  return querySnapshot.docs;
});
