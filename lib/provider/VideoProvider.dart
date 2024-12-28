import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/ui/widget/common/FilterRecipe.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final recommendVideosProvider = FutureProvider.autoDispose<List<VideoData>>((ref) async {
  // Firestore에서 "recommend" 섹션의 비디오 데이터를 가져옵니다.
  final querySnapshot = await FirebaseFirestore.instance
      .collection('videos')
      .where('section', isEqualTo: 'recommend') // "recommend" 섹션의 영상만 가져옴
      .get();

  List<VideoData> videos = [];

  // 비디오 데이터를 가져온 후 각 비디오에 대해 레시피 데이터를 가져옵니다.
  for (var doc in querySnapshot.docs) {
    final data = doc.data() as Map<String, dynamic>;

    // 비디오 데이터 생성
    VideoData videoData = VideoData.fromJson({
      'id': doc.id, // 문서 ID 추가
      'video_id': doc.id, // 비디오 ID 설정
      ...data, // 기존 데이터 추가
    });

    // 비디오 ID에 해당하는 레시피 데이터 가져오기
    List<RecipeData> recipes = await _fetchRecipesForVideo(videoData.videoId);
    // 레시피가 존재하면 첫 번째 레시피를 설정합니다.
    videoData = videoData.copyWith(recipe: recipes.isNotEmpty ? recipes[0] : RecipeData());
    videos.add(videoData);
  }

  return videos; // 최종 비디오 리스트 반환
});

// 특정 비디오에 대한 레시피 데이터를 가져오는 비동기 메서드
Future<List<RecipeData>> _fetchRecipesForVideo(String videoId) async {
  try {
    // 레시피 컬렉션에서 video_id가 일치하는 데이터를 가져옵니다.
    QuerySnapshot recipeSnapshot = await FirebaseFirestore.instance
        .collection('recipe') // 레시피 컬렉션
        .where('video_id', isEqualTo: videoId) // video_id가 비디오 ID와 일치하는 레시피
        .get();

    // 레시피 데이터를 리스트로 변환하여 반환합니다.
    return await Future.wait(recipeSnapshot.docs.map((doc) async {
      final recipeData = RecipeData.fromJson(doc.data() as Map<String, dynamic>);

      // 각 레시피에 대한 하위 컬렉션 데이터를 가져옵니다.
      List<CookingMethod> cookingMethods = await _fetchSubCollection<CookingMethod>(
        doc.id, 'cooking_methods', CookingMethod.fromJson,
      );
      List<Ingredient> ingredients = await _fetchSubCollection<Ingredient>(
        doc.id, 'ingredients', Ingredient.fromJson,
      );
      List<Equipment> equipment = await _fetchSubCollection<Equipment>(
        doc.id, 'equipment', Equipment.fromJson,
      );

      // RecipeData에 하위 컬렉션 데이터 추가
      return recipeData.copyWith(
        cookingMethods: cookingMethods,
        ingredients: ingredients,
        equipment: equipment,
      );
    }).toList());
  } catch (e) {
    print("Error fetching recipes for video: $e");
    return []; // 오류 발생 시 빈 리스트 반환
  }
}

// 하위 컬렉션 데이터를 가져오는 제네릭 메서드
Future<List<T>> _fetchSubCollection<T>(
    String recipeId,
    String subCollectionName,
    T Function(Map<String, dynamic>) fromJson,
    ) async {
  try {
    QuerySnapshot subCollectionSnapshot = await FirebaseFirestore.instance
        .collection('recipe') // 레시피 컬렉션
        .doc(recipeId) // 해당 레시피 문서
        .collection(subCollectionName) // 하위 컬렉션 이름
        .get();

    // 하위 컬렉션 데이터를 리스트로 변환하여 반환
    return subCollectionSnapshot.docs.map((doc) {
      return fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  } catch (e) {
    print("Error fetching $subCollectionName for recipe $recipeId: $e");
    return []; // 오류 발생 시 빈 리스트 반환
  }
}



// 채널의 추천 영상을 가져오는 FutureProvider
final channelVideosProvider =
FutureProvider.autoDispose.family<List<Map<String, dynamic>>, String>((ref, channelId) async {
  // Firestore에서 'channels' 컬렉션의 특정 채널 문서를 참조하여 'videos' 서브컬렉션 데이터를 가져옴
  final querySnapshot = await FirebaseFirestore.instance
      .collection('channels') // 'channels' 컬렉션
      .doc(channelId) // 특정 채널 ID
      .collection('videos') // 해당 채널의 'videos' 서브컬렉션
      .orderBy('view_count', descending: true) // 'view_count' 기준 내림차순 정렬
      .limit(3) // 최대 3개 비디오만 가져옴
      .get();

  // 가져온 데이터를 리스트로 변환
  List<Map<String, dynamic>> videos = await Future.wait(querySnapshot.docs.map((doc) async {
    final data = doc.data() as Map<String, dynamic>;

    // 각 문서에서 데이터와 ID를 포함한 맵을 생성
    String videoId = doc.id; // 비디오 문서 ID

    // 비디오 ID에 해당하는 레시피 데이터 가져오기
    List<RecipeData> recipes = await _fetchRecipesForVideo(videoId);

    // 레시피가 존재하면 첫 번째 레시피를 설정
    RecipeData? firstRecipe = recipes.isNotEmpty ? recipes[0] : null;

    return {
      'id': videoId, // 문서 ID
      'video_id': videoId, // 비디오 문서 ID
      ...data, // 기존 데이터 추가
      'recipe': firstRecipe?.toJson(), // 첫 번째 레시피를 JSON 형식으로 추가
    };
  }).toList());

  return videos; // 최종 비디오 리스트 반환
});


// videosByChannelProvider 정의
final videosByChannelProvider = FutureProvider.autoDispose.family<List<Map<String, dynamic>>, Map<String, dynamic>>(
      (ref, params) async {
    try {
      // params에서 채널 ID, 필터, 시작 문서 추출
      final String channelId = params['channel_id'] as String; // 채널 ID
      final FilterOption selectedFilter = params['filter'] as FilterOption; // 선택한 필터
      final DocumentSnapshot? startAfterDocument = params['start_after'] as DocumentSnapshot?; // 페이지네이션을 위한 시작 문서

      // Firestore에서 해당 채널의 비디오 컬렉션 쿼리
      Query<Map<String, dynamic>> query = FirebaseFirestore.instance
          .collection('channels')
          .doc(channelId)
          .collection('videos'); // 채널 비디오 콜렉션 접근

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

      // 페이지네이션: 시작 문서가 있을 경우 설정
      if (startAfterDocument != null) {
        query = query.startAfterDocument(startAfterDocument);
      }

      // 쿼리 실행 및 결과 반환
      final querySnapshot = await query.limit(10).get(); // 한 번에 10개 문서 가져옴

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
      // 에러 처리
      throw Exception('쿼리 실패: $e');
    }
  },
);