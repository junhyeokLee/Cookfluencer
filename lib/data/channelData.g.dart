// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channelData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelDataImpl _$$ChannelDataImplFromJson(Map<String, dynamic> json) =>
    _$ChannelDataImpl(
      id: json['id'] as String? ?? "",
      channelName: json['channel_name'] as String? ?? "",
      channelDescription: json['channel_description'] as String? ?? "",
      channelUrl: json['channel_url'] as String? ?? "",
      thumbnailUrl: json['thumbnail_url'] as String? ?? "",
      subscriberCount: (json['subscriber_count'] as num?)?.toInt() ?? 0,
      videoCount: (json['video_count'] as num?)?.toInt() ?? 0,
      uploadDate: json['upload_date'] as String? ?? "",
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => VideoData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VideoData>[],
      section: json['section'] as String? ?? "",
      isLiked: json['isLiked'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChannelDataImplToJson(_$ChannelDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'channel_name': instance.channelName,
      'channel_description': instance.channelDescription,
      'channel_url': instance.channelUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'subscriber_count': instance.subscriberCount,
      'video_count': instance.videoCount,
      'upload_date': instance.uploadDate,
      'videos': instance.videos,
      'section': instance.section,
      'isLiked': instance.isLiked,
    };
