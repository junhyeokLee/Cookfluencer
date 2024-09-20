// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'videoData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VideoDataImpl _$$VideoDataImplFromJson(Map<String, dynamic> json) =>
    _$VideoDataImpl(
      id: json['id'] as String? ?? "",
      channelId: json['channel_id'] as String? ?? "",
      channelName: json['channel_name'] as String? ?? "",
      description: json['description'] as String? ?? "",
      thumbnailUrl: json['thumbnail_url'] as String? ?? "",
      title: json['title'] as String? ?? "",
      uploadDate: json['upload_data'] as String? ?? "",
      videoId: json['video_id'] as String? ?? "",
      videoUrl: json['video_url'] as String? ?? "",
      viewCount: (json['view_count'] as num?)?.toInt() ?? 0,
      section: json['section'] as String? ?? "",
      isLiked: json['isLiked'] as bool? ?? false,
    );

Map<String, dynamic> _$$VideoDataImplToJson(_$VideoDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_id': instance.channelId,
      'channel_name': instance.channelName,
      'description': instance.description,
      'thumbnail_url': instance.thumbnailUrl,
      'title': instance.title,
      'upload_data': instance.uploadDate,
      'video_id': instance.videoId,
      'video_url': instance.videoUrl,
      'view_count': instance.viewCount,
      'section': instance.section,
      'isLiked': instance.isLiked,
    };
