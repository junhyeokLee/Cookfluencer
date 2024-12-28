import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// 채널 리스트를 비동기로 가져오는 프로바이더
final channelListProvider = StreamProvider.autoDispose((ref) {
  return FirebaseFirestore.instance.collection('channels').snapshots();
});

// 추천 채널 리스트를 가져오는 Provider
final recommendChannelsProvider =
    FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('section', isEqualTo: 'recommend') // "recommend" 섹션의 영상만 가져옴
      .orderBy('subscriber_count', descending: true) // 구독자 수 내림차순으로 정렬
      .get();

  return querySnapshot.docs;
});


Future<void> updateViewCounts() async {
  final videosCollection = FirebaseFirestore.instance.collection('videos');
  final querySnapshot = await videosCollection.get();

  for (var doc in querySnapshot.docs) {
    final data = doc.data();
    if (data['view_count'] is String) {
      // 문자열로 저장된 view_count를 숫자로 변환
      int viewCount = int.tryParse(data['view_count']) ?? 0; // 변환 실패 시 0으로 설정
      await doc.reference.update({'view_count': viewCount});
    }
  }
}

final channelByIdProvider = FutureProvider.autoDispose
    .family<DocumentSnapshot, String>((ref, channelId) async {
  // 채널 ID가 비어있는 경우 예외 처리
  if (channelId.isEmpty) throw Exception('채널 ID가 비어있습니다.');

  // Firestore에서 해당 채널 ID의 문서를 가져옴
  final documentSnapshot = await FirebaseFirestore.instance
      .collection('channels') // 'channels' 컬렉션에 접근
      .doc(channelId) // 특정 채널 ID에 해당하는 문서를 찾음
      .get(); // 문서 가져오기

  // 문서가 존재하지 않으면 예외 처리
  if (!documentSnapshot.exists) {
    throw Exception('해당 채널을 찾을 수 없습니다.');
  }

  // 채널 데이터를 반환
  return documentSnapshot;
});