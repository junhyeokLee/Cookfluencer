// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seasonData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SeasonDataImpl _$$SeasonDataImplFromJson(Map<String, dynamic> json) =>
    _$SeasonDataImpl(
      id: json['id'] as String? ?? "",
      title: json['title'] as String? ?? "",
      sub_title: json['sub_title'] as String? ?? "",
      image: json['image'] as String? ?? "",
      videos: (json['videos'] as List<dynamic>?)
              ?.map((e) => VideoData.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <VideoData>[],
    );

Map<String, dynamic> _$$SeasonDataImplToJson(_$SeasonDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'sub_title': instance.sub_title,
      'image': instance.image,
      'videos': instance.videos,
    };
