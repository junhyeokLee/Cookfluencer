import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:cookfluencer/data/seasonData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// season 컬렉션을 실시간으로 가져오는 StreamProvider
final seasonListProvider = FutureProvider.autoDispose<List<SeasonData>>((ref) async {
  // Firestore에서 season 컬렉션의 스냅샷을 가져옴
  final seasonSnapshots = await FirebaseFirestore.instance
      .collection('season')
      .orderBy('position') // position 필드로 오름차순 정렬
      .get();

  // 각 시즌 문서에 대해 비디오와 레시피 데이터를 가져옴
  final List<SeasonData> seasonList = await Future.wait(seasonSnapshots.docs.map((doc) async {
    // 각 season 문서의 하위 컬렉션인 videos를 가져옴
    final videoSnapshots = await doc.reference.collection('videos').get();

    // 비디오 데이터 리스트
    List<VideoData> videos = [];

    for (var videoDoc in videoSnapshots.docs) {
      // 비디오 데이터 생성
      VideoData videoData = VideoData.fromJson({
        'id': videoDoc.id, // 비디오 문서 ID
        ...videoDoc.data() as Map<String, dynamic>, // 기존 비디오 데이터
      });

      // 비디오 ID에 해당하는 레시피 데이터 가져오기
      List<RecipeData> recipes = await _fetchRecipesForVideo(videoData.videoId);

      // 레시피가 존재하면 첫 번째 레시피를 설정합니다.
      videoData = videoData.copyWith(recipe: recipes.isNotEmpty ? recipes[0] : RecipeData()); // 첫 번째 레시피 설정

      videos.add(videoData); // 비디오 리스트에 추가
    }

    return SeasonData(
      id: doc.id,
      title: doc['title'], // 시즌 제목 (예시)
      sub_title: doc['sub_title'], // 시즌 부제목 (예시)
      image: doc['image'], // 시즌 이미지 (예시)
      videos: videos, // 비디오 리스트 추가
    );
  }).toList());

  return seasonList; // 최종 시즌 리스트 반환
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


// final seasonListProvider = StreamProvider.autoDispose((ref) async* {
//   // Firestore에서 season 컬렉션의 스냅샷을 구독
//   final seasonSnapshots = FirebaseFirestore.instance
//       .collection('season')
//       .orderBy('position') // position 필드로 오름차순 정렬
//       .snapshots();
//
//   // 각 문서에 대해 처리하기 위해 Stream을 변환
//   await for (final snapshot in seasonSnapshots) {
//     // 각 문서에 대해 데이터와 문서 ID를 함께 매핑
//     final List<Map<String, dynamic>> seasonList = await Future.wait(snapshot.docs.map((doc) async {
//       // 각 season 문서의 하위 컬렉션인 videos를 가져옴
//       final videoSnapshots = await doc.reference.collection('videos').get();
//
//       // 문서 ID를 id 필드로 추가하고, videos 데이터를 함께 추가
//       return {
//         ...doc.data(), // 문서 필드 데이터
//         'id': doc.id, // 문서 ID
//         'videos': videoSnapshots.docs.map((videoDoc) => videoDoc.data()).toList(), // videos 하위 컬렉션 데이터
//       };
//     }).toList());
//
//     // 데이터를 스트림으로 내보냄
//     yield seasonList;
//   }
// });