import 'package:cookfluencer/data/videoData.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'channelData.freezed.dart';
part 'channelData.g.dart';

@freezed
class ChannelData with _$ChannelData {
  const factory ChannelData({
    @Default("") String id,
    @Default("") String channelName,
    @Default("") String channelDescription,
    @Default("") String channelUrl,
    @Default("") String thumbnailUrl,
    @Default(0) int subscriberCount,
    @Default(0) int videoCount,
    @Default(<VideoData>[]) List<VideoData> videos, // 리스트 타입으로 수정
    @Default("") String section,
    @Default(false) bool isLiked, // 좋아요 상태 추가
  }) = _ChannelData;

  factory ChannelData.fromJson(Map<String, dynamic> json) => _$ChannelDataFromJson(json);
}
