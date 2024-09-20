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
    @JsonKey(name: 'upload_data') @Default("") String uploadDate, // 기본값 수정
    @JsonKey(name: 'video_id') @Default("") String videoId,
    @JsonKey(name: 'video_url') @Default("") String videoUrl,
    @JsonKey(name: 'view_count') @Default(0) int viewCount,
    @JsonKey(name: 'section') @Default("") String section,
    @Default(false) bool isLiked, // 좋아요 상태 추가
  }) = _VideoData;

  factory VideoData.fromJson(Map<String, dynamic> json) => _$VideoDataFromJson(json);
}
