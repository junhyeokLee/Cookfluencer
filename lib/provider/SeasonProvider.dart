import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// season 컬렉션을 실시간으로 가져오는 StreamProvider
final seasonListProvider = StreamProvider.autoDispose((ref) async* {
  // Firestore에서 season 컬렉션의 스냅샷을 구독
  final seasonSnapshots = FirebaseFirestore.instance
      .collection('season')
      .orderBy('position') // position 필드로 오름차순 정렬
      .snapshots();

  // 각 문서에 대해 처리하기 위해 Stream을 변환
  await for (final snapshot in seasonSnapshots) {
    // 각 문서에 대해 데이터와 문서 ID를 함께 매핑
    final List<Map<String, dynamic>> seasonList = await Future.wait(snapshot.docs.map((doc) async {
      // 각 season 문서의 하위 컬렉션인 videos를 가져옴
      final videoSnapshots = await doc.reference.collection('videos').get();

      // 문서 ID를 id 필드로 추가하고, videos 데이터를 함께 추가
      return {
        ...doc.data(), // 문서 필드 데이터
        'id': doc.id, // 문서 ID
        'videos': videoSnapshots.docs.map((videoDoc) => videoDoc.data()).toList(), // videos 하위 컬렉션 데이터
      };
    }).toList());

    // 데이터를 스트림으로 내보냄
    yield seasonList;
  }
});