// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'videoData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

VideoData _$VideoDataFromJson(Map<String, dynamic> json) {
  return _VideoData.fromJson(json);
}

/// @nodoc
mixin _$VideoData {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'channel_id')
  String get channelId => throw _privateConstructorUsedError;
  @JsonKey(name: 'channel_name')
  String get channelName => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'thumbnail_url')
  String get thumbnailUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'title')
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'upload_data')
  String get uploadDate => throw _privateConstructorUsedError; // 기본값 수정
  @JsonKey(name: 'video_id')
  String get videoId => throw _privateConstructorUsedError;
  @JsonKey(name: 'video_url')
  String get videoUrl => throw _privateConstructorUsedError;
  @JsonKey(name: 'view_count')
  int get viewCount => throw _privateConstructorUsedError;
  @JsonKey(name: 'section')
  String get section => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;

  /// Serializes this VideoData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideoDataCopyWith<VideoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideoDataCopyWith<$Res> {
  factory $VideoDataCopyWith(VideoData value, $Res Function(VideoData) then) =
      _$VideoDataCopyWithImpl<$Res, VideoData>;
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'channel_id') String channelId,
      @JsonKey(name: 'channel_name') String channelName,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'thumbnail_url') String thumbnailUrl,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'upload_data') String uploadDate,
      @JsonKey(name: 'video_id') String videoId,
      @JsonKey(name: 'video_url') String videoUrl,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'section') String section,
      bool isLiked});
}

/// @nodoc
class _$VideoDataCopyWithImpl<$Res, $Val extends VideoData>
    implements $VideoDataCopyWith<$Res> {
  _$VideoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? channelId = null,
    Object? channelName = null,
    Object? description = null,
    Object? thumbnailUrl = null,
    Object? title = null,
    Object? uploadDate = null,
    Object? videoId = null,
    Object? videoUrl = null,
    Object? viewCount = null,
    Object? section = null,
    Object? isLiked = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: null == uploadDate
          ? _value.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as String,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$VideoDataImplCopyWith<$Res>
    implements $VideoDataCopyWith<$Res> {
  factory _$$VideoDataImplCopyWith(
          _$VideoDataImpl value, $Res Function(_$VideoDataImpl) then) =
      __$$VideoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      @JsonKey(name: 'channel_id') String channelId,
      @JsonKey(name: 'channel_name') String channelName,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'thumbnail_url') String thumbnailUrl,
      @JsonKey(name: 'title') String title,
      @JsonKey(name: 'upload_data') String uploadDate,
      @JsonKey(name: 'video_id') String videoId,
      @JsonKey(name: 'video_url') String videoUrl,
      @JsonKey(name: 'view_count') int viewCount,
      @JsonKey(name: 'section') String section,
      bool isLiked});
}

/// @nodoc
class __$$VideoDataImplCopyWithImpl<$Res>
    extends _$VideoDataCopyWithImpl<$Res, _$VideoDataImpl>
    implements _$$VideoDataImplCopyWith<$Res> {
  __$$VideoDataImplCopyWithImpl(
      _$VideoDataImpl _value, $Res Function(_$VideoDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? channelId = null,
    Object? channelName = null,
    Object? description = null,
    Object? thumbnailUrl = null,
    Object? title = null,
    Object? uploadDate = null,
    Object? videoId = null,
    Object? videoUrl = null,
    Object? viewCount = null,
    Object? section = null,
    Object? isLiked = null,
  }) {
    return _then(_$VideoDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      channelId: null == channelId
          ? _value.channelId
          : channelId // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      uploadDate: null == uploadDate
          ? _value.uploadDate
          : uploadDate // ignore: cast_nullable_to_non_nullable
              as String,
      videoId: null == videoId
          ? _value.videoId
          : videoId // ignore: cast_nullable_to_non_nullable
              as String,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      viewCount: null == viewCount
          ? _value.viewCount
          : viewCount // ignore: cast_nullable_to_non_nullable
              as int,
      section: null == section
          ? _value.section
          : section // ignore: cast_nullable_to_non_nullable
              as String,
      isLiked: null == isLiked
          ? _value.isLiked
          : isLiked // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideoDataImpl implements _VideoData {
  const _$VideoDataImpl(
      {this.id = "",
      @JsonKey(name: 'channel_id') this.channelId = "",
      @JsonKey(name: 'channel_name') this.channelName = "",
      @JsonKey(name: 'description') this.description = "",
      @JsonKey(name: 'thumbnail_url') this.thumbnailUrl = "",
      @JsonKey(name: 'title') this.title = "",
      @JsonKey(name: 'upload_data') this.uploadDate = "",
      @JsonKey(name: 'video_id') this.videoId = "",
      @JsonKey(name: 'video_url') this.videoUrl = "",
      @JsonKey(name: 'view_count') this.viewCount = 0,
      @JsonKey(name: 'section') this.section = "",
      this.isLiked = false});

  factory _$VideoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideoDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey(name: 'channel_id')
  final String channelId;
  @override
  @JsonKey(name: 'channel_name')
  final String channelName;
  @override
  @JsonKey(name: 'description')
  final String description;
  @override
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  @override
  @JsonKey(name: 'title')
  final String title;
  @override
  @JsonKey(name: 'upload_data')
  final String uploadDate;
// 기본값 수정
  @override
  @JsonKey(name: 'video_id')
  final String videoId;
  @override
  @JsonKey(name: 'video_url')
  final String videoUrl;
  @override
  @JsonKey(name: 'view_count')
  final int viewCount;
  @override
  @JsonKey(name: 'section')
  final String section;
  @override
  @JsonKey()
  final bool isLiked;

  @override
  String toString() {
    return 'VideoData(id: $id, channelId: $channelId, channelName: $channelName, description: $description, thumbnailUrl: $thumbnailUrl, title: $title, uploadDate: $uploadDate, videoId: $videoId, videoUrl: $videoUrl, viewCount: $viewCount, section: $section, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideoDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.channelId, channelId) ||
                other.channelId == channelId) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.uploadDate, uploadDate) ||
                other.uploadDate == uploadDate) &&
            (identical(other.videoId, videoId) || other.videoId == videoId) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.viewCount, viewCount) ||
                other.viewCount == viewCount) &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      channelId,
      channelName,
      description,
      thumbnailUrl,
      title,
      uploadDate,
      videoId,
      videoUrl,
      viewCount,
      section,
      isLiked);

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideoDataImplCopyWith<_$VideoDataImpl> get copyWith =>
      __$$VideoDataImplCopyWithImpl<_$VideoDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideoDataImplToJson(
      this,
    );
  }
}

abstract class _VideoData implements VideoData {
  const factory _VideoData(
      {final String id,
      @JsonKey(name: 'channel_id') final String channelId,
      @JsonKey(name: 'channel_name') final String channelName,
      @JsonKey(name: 'description') final String description,
      @JsonKey(name: 'thumbnail_url') final String thumbnailUrl,
      @JsonKey(name: 'title') final String title,
      @JsonKey(name: 'upload_data') final String uploadDate,
      @JsonKey(name: 'video_id') final String videoId,
      @JsonKey(name: 'video_url') final String videoUrl,
      @JsonKey(name: 'view_count') final int viewCount,
      @JsonKey(name: 'section') final String section,
      final bool isLiked}) = _$VideoDataImpl;

  factory _VideoData.fromJson(Map<String, dynamic> json) =
      _$VideoDataImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'channel_id')
  String get channelId;
  @override
  @JsonKey(name: 'channel_name')
  String get channelName;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'thumbnail_url')
  String get thumbnailUrl;
  @override
  @JsonKey(name: 'title')
  String get title;
  @override
  @JsonKey(name: 'upload_data')
  String get uploadDate; // 기본값 수정
  @override
  @JsonKey(name: 'video_id')
  String get videoId;
  @override
  @JsonKey(name: 'video_url')
  String get videoUrl;
  @override
  @JsonKey(name: 'view_count')
  int get viewCount;
  @override
  @JsonKey(name: 'section')
  String get section;
  @override
  bool get isLiked;

  /// Create a copy of VideoData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideoDataImplCopyWith<_$VideoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
