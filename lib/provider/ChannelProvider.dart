import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:flutter/cupertino.dart';
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

// 추천 레시피 리스트를 가져오는 Provider
final recommendVideosProvider =
    FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('section', isEqualTo: 'recommend') // "recommend" 섹션의 영상만 가져옴
      .get();

  return querySnapshot.docs;
});

// 채널의 추천 영상 가져오기
final channelVideosProvider = FutureProvider.autoDispose
    .family<List<QueryDocumentSnapshot>, String>((ref, channelId) async {
  // Firestore에서 videos 컬렉션의 데이터를 가져옴
  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .doc(channelId)
      .collection('videos')
      // .where('section', isEqualTo: 'top3recommend')
      .orderBy('view_count', descending: true) // view_count를 기준으로 내림차순 정렬
      .limit(3) // 최대 3개만 가져옴
      .get();

  // 가져온 데이터를 리스트로 변환
  return querySnapshot.docs; // 비디오 리스트 반환
});

final keywordListProvider =
    FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final querySnapshot =
      await FirebaseFirestore.instance.collection('keyword').get();

  return querySnapshot.docs;
});

// Firestore에서 채널 데이터를 검색하는 Provider
final searchKeywordVideoProvider = FutureProvider.autoDispose
    .family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환
  if (searchQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('title', isGreaterThanOrEqualTo: searchQuery)
      .where('title',
          isLessThanOrEqualTo:
              searchQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
      .limit(4)
      .get();

  return querySnapshot.docs;
});

// Firestore에서 채널 데이터를 검색하는 Provider
final searchVideoProvider = FutureProvider.autoDispose.family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환
  if (searchQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('title', isGreaterThanOrEqualTo: searchQuery)
      .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
      .get();

  return querySnapshot.docs;
});

// 비디오를 조회수 또는 최신순으로 검색하는 Provider
final searchFilterVideoProvider = FutureProvider.autoDispose.family<List<QueryDocumentSnapshot>, Map<String, dynamic>>(
        (ref, searchParams) async {
      try {
        final searchQuery = searchParams['query'] as String;
        final selectedFilter = searchParams['filter'] as FilterOption;
        final lastDocument = searchParams['lastDocument'] as DocumentSnapshot?; // 마지막 문서 추가

        debugPrint('searchQuery: $searchQuery');
        debugPrint('selectedFilter: $selectedFilter');

        if (searchQuery.isEmpty) return [];

        // 기본 쿼리: 제목 기준으로 검색
        Query<Map<String, dynamic>> query = FirebaseFirestore.instance
            .collection('videos')
            .where('title', isGreaterThanOrEqualTo: searchQuery)
            .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff')
            .limit(10); // 한 번에 가져올 데이터 수

        // 마지막 문서가 있을 경우, 그 이후부터 가져오도록 쿼리 수정
        if (lastDocument != null) {
          query = query.startAfterDocument(lastDocument);
        }

        // 인기순(조회수) 필터 적용
        if (selectedFilter == FilterOption.viewCount) {
          query = query
              .orderBy('view_count', descending: true) // 조회수 순으로 정렬
              .orderBy('title'); // 제목으로도 정렬 (필요한 경우)
        }
        // 최신순 필터 적용
        else if (selectedFilter == FilterOption.latest) {
          query = query
              .orderBy('upload_date', descending: true) // 최신순으로 정렬
              .orderBy('title'); // 제목으로도 정렬 (필요한 경우)
        }

        final querySnapshot = await query.get();
        return querySnapshot.docs;
      } catch (e) {
        // 오류 발생 시 throw
        throw Exception('쿼리 실패: $e');
      }
    }
);


// Firestore에서 채널과 비디오 데이터를 검색하는 Provider
final searchChannelAndVideoProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환
  if (searchQuery.isEmpty) return [];

  List<Map<String, dynamic>> results = [];

  // 채널에서 검색하기
  final channelQuerySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: searchQuery)
      .where('channel_name', isLessThanOrEqualTo: searchQuery + '\uf8ff')
      .limit(5)
      .get();

  // 채널 이름 리스트 생성
  results.addAll(channelQuerySnapshot.docs.map((doc) {
    final channelName = doc['channel_name'] ?? ''; // null 체크
    return {
      'type': 'channel',
      'title': channelName,
    };
  }));

  // 비디오에서 검색하기
  final videoQuerySnapshot = await FirebaseFirestore.instance
      .collection('videos') // 비디오 컬렉션 이름
      .where('title', isGreaterThanOrEqualTo: searchQuery)
      .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff')
      .limit(5)
      .get();

  // 비디오 제목 리스트 생성
  results.addAll(videoQuerySnapshot.docs.map((videoDoc) {
    final videoTitle = videoDoc['title'] ?? ''; // null 체크
    return {
      'type': 'video',
      'title': videoTitle,
    };
  }));

  // 채널 이름과 비디오 제목을 함께 반환
  return results;
});

// Firestore에서 채널과 비디오 데이터를 검색하는 Provider
final searchChannelProvider = FutureProvider.autoDispose
    .family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환

  if (searchQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: searchQuery)
      .where('channel_name', isLessThanOrEqualTo: searchQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
      .limit(5)
      .get();

  return querySnapshot.docs;
});

// Firestore에서 채널과 비디오 데이터를 검색하는 Provider
final searchTotalChannelProvider = FutureProvider.autoDispose
    .family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환

  if (searchQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: searchQuery)
      .where('channel_name', isLessThanOrEqualTo: searchQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
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