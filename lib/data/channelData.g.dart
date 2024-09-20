// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'channelData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChannelDataImpl _$$ChannelDataImplFromJson(Map<String, dynamic> json) =>
    _$ChannelDataImpl(
      id: json['id'] as String? ?? "",
      channelName: json['channelName'] as String? ?? "",
      channelDescription: json['channelDescription'] as String? ?? "",
      channelUrl: json['channelUrl'] as String? ?? "",
      thumbnailUrl: json['thumbnailUrl'] as String? ?? "",
      subscriberCount: (json['subscriberCount'] as num?)?.toInt() ?? 0,
      videoCount: (json['videoCount'] as num?)?.toInt() ?? 0,
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
      'channelName': instance.channelName,
      'channelDescription': instance.channelDescription,
      'channelUrl': instance.channelUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'subscriberCount': instance.subscriberCount,
      'videoCount': instance.videoCount,
      'videos': instance.videos,
      'section': instance.section,
      'isLiked': instance.isLiked,
    };
