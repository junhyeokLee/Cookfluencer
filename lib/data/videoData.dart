import 'package:algolia/algolia.dart';
import 'package:cookfluencer/data/recipeData.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'videoData.freezed.dart';
part 'videoData.g.dart';

@freezed
class VideoData with _$VideoData {
  const factory VideoData({
    @Default("") String id,
    @JsonKey(name: 'channel_id') @Default("") String channelId,
    @JsonKey(name: 'channel_name') @Default("") String channelName,
    @JsonKey(name: 'description') @Default("") String description,
    @JsonKey(name: 'thumbnail_url') @Default("") String thumbnailUrl,
    @JsonKey(name: 'title') @Default("") String title,
    @JsonKey(name: 'upload_data') @Default("") String uploadDate,
    @JsonKey(name: 'video_id') @Default("") String videoId,
    @JsonKey(name: 'video_url') @Default("") String videoUrl,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'section') @Default("") String section,
    RecipeData? recipe, // 하나의 레시피 추가
    @Default(false) bool isLiked,
  }) = _VideoData;



  // Algolia 데이터로부터 VideoData 생성
  factory VideoData.fromAlgoliaHit(AlgoliaObjectSnapshot hit) {
    return VideoData(
      id: hit.data['id'] ?? '',
      channelId: hit.data['channel_id'] ?? '',
      channelName: hit.data['channel_name'] ?? '',
      description: hit.data['description'] ?? '',
      thumbnailUrl: hit.data['thumbnail_url'] ?? '',
      title: hit.data['title'] ?? '',
      uploadDate: hit.data['upload_date'] ?? '',
      videoId: hit.data['video_id'] ?? '',
      videoUrl: hit.data['video_url'] ?? '',
      viewCount: hit.data['view_count'] ?? 0,
      section: hit.data['section'] ?? '',
      recipe: hit.data['recipe'] != null ? RecipeData.fromJson(hit.data['recipe']) : null,
      isLiked: hit.data['isLiked'] ?? false,
    );
  }


  factory VideoData.fromJson(Map<String, dynamic> json) => _$VideoDataFromJson(json);
}
