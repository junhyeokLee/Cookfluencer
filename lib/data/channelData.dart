import 'package:algolia/algolia.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'channelData.freezed.dart';
part 'channelData.g.dart';

@freezed
class ChannelData with _$ChannelData {
  const factory ChannelData({
    @JsonKey(name: 'id') @Default("") String id,
    @JsonKey(name: 'channel_name') @Default("") String channelName,
    @JsonKey(name: 'channel_description') @Default("") String channelDescription,
    @JsonKey(name: 'channel_url') @Default("") String channelUrl,
    @JsonKey(name: 'thumbnail_url') @Default("") String thumbnailUrl,
    @JsonKey(name: 'subscriber_count') @Default(0) int subscriberCount,
    @JsonKey(name: 'video_count') @Default(0) int videoCount,
    @Default(<VideoData>[]) List<VideoData> videos, // 리스트 타입으로 수정
    @JsonKey(name: 'section') @Default("") String section,
    @Default(false) bool isLiked, // 좋아요 상태 추가
  }) = _ChannelData;


  // Algolia 데이터로부터 VideoData 생성
  factory ChannelData.fromAlgoliaHit(AlgoliaObjectSnapshot hit) {
    return ChannelData(
      id: hit.data['id'] ?? '', // Algolia 데이터에서 id 가져오기
      channelName: hit.data['channel_name'] ?? '', // Algolia 데이터에서 channel_name 가져오기
      channelDescription: hit.data['channel_description'] ?? '',
      channelUrl: hit.data['channel_url'] ?? '',
      thumbnailUrl: hit.data['thumbnail_url'] ?? '',
      subscriberCount: hit.data['subscriber_count'] ?? 0,
      videoCount: hit.data['video_count'] ?? 0,
      section: hit.data['section'] ?? '',
      isLiked: hit.data['isLiked'] ?? false, // Algolia에서 좋아요 상태 가져오기
    );
  }


  factory ChannelData.fromJson(Map<String, dynamic> json) => _$ChannelDataFromJson(json);
}
