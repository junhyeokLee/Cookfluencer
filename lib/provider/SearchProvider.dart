import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/common/SearchMetadata.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final keywordListProvider =
FutureProvider.autoDispose<List<QueryDocumentSnapshot>>((ref) async {
  final querySnapshot =
  await FirebaseFirestore.instance.collection('keyword').get();

  return querySnapshot.docs;
});

final searchFilterVideoProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>(
      (ref, params) async {
    try {
      // 검색어를 가져오고 공백 제거
      final String searchQuery = params['query']?.toString().trim() ?? '';
      final FilterOption selectedFilter = params['filter'] as FilterOption;
      final DocumentSnapshot? startAfterDocument = params['start_after'] as DocumentSnapshot?;

      // 검색어가 비어 있으면 빈 리스트 반환
      if (searchQuery.isEmpty) return [];

      // FirebaseFirestore 쿼리 생성
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('videos')
          .where('title', isGreaterThanOrEqualTo: searchQuery)
          .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff');

      // 필터 옵션에 따른 정렬 처리
      if (selectedFilter == FilterOption.viewCount) {
        query = query.orderBy('view_count', descending: true).orderBy('title');
      } else if (selectedFilter == FilterOption.latest) {
        query = query.orderBy('upload_date', descending: true).orderBy('title');
      }

      // 페이지네이션 처리를 위해 startAfterDocument가 있으면 해당 문서 뒤에서부터 쿼리 시작
      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      // 한 번에 최대 10개의 문서 가져오기
      final querySnapshot = await query.limit(10).get();

      // 데이터가 없을 경우 빈 리스트 또는 에러 처리
      if (querySnapshot.docs.isEmpty) {
        return []; // 초기 요청에서 데이터가 없을 경우 빈 리스트 반환
      }

      // 비디오와 관련된 레시피 데이터를 포함한 리스트 생성
      List<Map<String, dynamic>> videoWithRecipeList = [];
      for (var videoDoc in querySnapshot.docs) {
        final videoData = videoDoc.data(); // 비디오 데이터 가져오기

        // 비디오 ID와 일치하는 레시피 데이터 가져오기
        final recipeSnapshot = await FirebaseFirestore.instance
            .collection('recipe')
            .where('video_id', isEqualTo: videoDoc.id)
            .get();

        // 비디오 데이터와 레시피 데이터를 합쳐서 리스트에 추가
        videoWithRecipeList.add({
          ...videoData, // 비디오 데이터 복사
          'recipe': recipeSnapshot.docs.isNotEmpty ? recipeSnapshot.docs.first.data() : {}, // 레시피가 있으면 추가
          'document_snapshot': videoDoc, // 페이지네이션을 위한 DocumentSnapshot 포함
        });
      }

      return videoWithRecipeList;
    } catch (e) {
      throw Exception('쿼리 실패: $e');
    }
  },
);


// 비디오를 조회수 또는 최신순으로 검색하는 Provider
// final searchFilterVideoProvider =  FutureProvider.autoDispose.family<List<QueryDocumentSnapshot>, Map<String, dynamic>>(
//         (ref, params) async {
//       try {
//
//         final String searchQuery = params['query']?.toString().trim() ?? ''; // 공백 제거
//         final FilterOption selectedFilter = params['filter'] as FilterOption;
//         final DocumentSnapshot? startAfterDocument = params['start_after'] as DocumentSnapshot?; // 페이지네이션을 위한 시작 문서
//         // final trimmedQuery = searchQuery.trim().replaceAll(' ', ''); // 공백 제거
//
//         if (searchQuery.isEmpty) return [];
//
//         // 기본 쿼리: 제목 기준으로 검색
//         Query<Map<String, dynamic>> query = FirebaseFirestore.instance
//             .collection('videos')
//             .where('title', isGreaterThanOrEqualTo: searchQuery)
//             .where('title', isLessThanOrEqualTo: searchQuery + '\uf8ff');
//         // .limit(10); // 한 번에 가져올 데이터 수
//
//         // 인기순(조회수) 필터 적용
//         if (selectedFilter == FilterOption.viewCount) {
//           query = query
//               .orderBy('view_count', descending: true) // 조회수 순으로 정렬
//               .orderBy('title'); // 제목으로도 정렬 (필요한 경우)
//         }
//         // 최신순 필터 적용
//         else if (selectedFilter == FilterOption.latest) {
//           query = query
//               .orderBy('upload_date', descending: true) // 최신순으로 정렬
//               .orderBy('title'); // 제목으로도 정렬 (필요한 경우)
//         }
//
//         // 페이지네이션: 시작 문서가 있을 경우 설정
//         if (startAfterDocument != null) {
//           query = query.startAfterDocument(startAfterDocument);
//         }
//         // 쿼리 실행 및 결과 반환
//         final querySnapshot = await query.limit(10).get(); // 한 번에 10개 문서 가져옴
//         // 쿼리 결과가 비어 있고 페이지네이션을 하고 있을 때 예외 처리
//         if (querySnapshot.docs.isEmpty && startAfterDocument != null) {
//           throw Exception('인덱스가 필요할 수 있습니다. Firebase Console에서 인덱스를 생성하세요.');
//         }
//         return querySnapshot.docs;
//       } catch (e) {
//         // 오류 발생 시 throw
//         throw Exception('쿼리 실패: $e');
//       }
//     }
// );


final autoSearchChannelAndVideoProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, searchQuery) async {
  // 검색 쿼리에서 공백 제거
  final trimmedQuery = searchQuery.trim().replaceAll(' ', ''); // 공백 제거

  // 검색 쿼리가 비어있으면 빈 리스트 반환
  if (trimmedQuery.isEmpty) return [];

  List<Map<String, dynamic>> results = [];

  // 채널에서 검색하기
  final channelQuerySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: trimmedQuery) // 공백 제거된 쿼리
      .where('channel_name', isLessThanOrEqualTo: trimmedQuery + '\uf8ff') // 공백 제거된 쿼리
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
      .where('title', isGreaterThanOrEqualTo: trimmedQuery) // 공백 제거된 쿼리
      .where('title', isLessThanOrEqualTo: trimmedQuery + '\uf8ff') // 공백 제거된 쿼리
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
final autoSearchChannelProvider = FutureProvider.autoDispose
    .family<List<Map<String, dynamic>>, String>((ref, searchQuery) async {
  final trimmedQuery = searchQuery.trim().replaceAll(' ', ''); // 공백 제거

  // 검색 쿼리가 비어있으면 빈 리스트 반환
  if (trimmedQuery.isEmpty) return [];

  List<Map<String, dynamic>> results = [];

  // 채널에서 검색하기
  final channelQuerySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: trimmedQuery)
      .where('channel_name', isLessThanOrEqualTo: trimmedQuery + '\uf8ff')
      .limit(10)
      .get();

  // 채널 이름 리스트 생성
  results.addAll(channelQuerySnapshot.docs.map((doc) {
    final channelName = doc['channel_name'] ?? ''; // null 체크
    return {
      'type': 'channel',
      'title': channelName,
    };
  }));

  // 채널 이름과 비디오 제목을 함께 반환
  return results;
});


// Firestore에서 채널 데이터를 검색하는 Provider
final searchChannelProvider = FutureProvider.autoDispose
    .family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환
  final trimmedQuery = searchQuery.trim().replaceAll(' ', ''); // 공백 제거

  if (trimmedQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: trimmedQuery)
      .where('channel_name', isLessThanOrEqualTo: trimmedQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
      .limit(5)
      .get();

  return querySnapshot.docs;
});

// Firestore에서 채널과 비디오 데이터를 검색하는 Provider
final searchTotalChannelProvider = FutureProvider.autoDispose
    .family<List<QueryDocumentSnapshot>, String>((ref, searchQuery) async {
  // 검색 쿼리가 비어있으면 빈 리스트 반환
  final trimmedQuery = searchQuery.trim().replaceAll(' ', ''); // 공백 제거

  if (trimmedQuery.isEmpty) return [];

  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels')
      .where('channel_name', isGreaterThanOrEqualTo: trimmedQuery)
      .where('channel_name', isLessThanOrEqualTo: trimmedQuery + '\uf8ff') // 쿼리 범위를 지정해서 검색어에 맞는 결과만 가져오기
      .orderBy('subscriber_count', descending: true) // 조회수 순으로 정렬
      .orderBy('channel_name') // 제목으로도 정렬 (필요한 경우)
      .get();

  return querySnapshot.docs;
});


final hitsSearcherProvider = Provider<HitsSearcher>((ref) {
  return HitsSearcher(
    applicationID: 'MC84CR9U8O',
    apiKey: 'ecef53cb69da08b3e4f77e92cc600eb1',
    indexName: 'title',
  );
});

final searchMetadataProvider = StreamProvider<SearchMetadata>((ref) {
  final searcher = ref.watch(hitsSearcherProvider);
  return searcher.responses.map(SearchMetadata.fromResponse);
});

final _productsSearcher = HitsSearcher(applicationID: 'MC84CR9U8O',
    apiKey: 'ecef53cb69da08b3e4f77e92cc600eb1',
    indexName: 'videos');

Stream<SearchMetadata> get _searchMetadata => _productsSearcher.responses.map(SearchMetadata.fromResponse);
