// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'channelData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ChannelData _$ChannelDataFromJson(Map<String, dynamic> json) {
  return _ChannelData.fromJson(json);
}

/// @nodoc
mixin _$ChannelData {
  String get id => throw _privateConstructorUsedError;
  String get channelName => throw _privateConstructorUsedError;
  String get channelDescription => throw _privateConstructorUsedError;
  String get channelUrl => throw _privateConstructorUsedError;
  String get thumbnailUrl => throw _privateConstructorUsedError;
  int get subscriberCount => throw _privateConstructorUsedError;
  int get videoCount => throw _privateConstructorUsedError;
  List<VideoData> get videos =>
      throw _privateConstructorUsedError; // 리스트 타입으로 수정
  String get section => throw _privateConstructorUsedError;
  bool get isLiked => throw _privateConstructorUsedError;

  /// Serializes this ChannelData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ChannelData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ChannelDataCopyWith<ChannelData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChannelDataCopyWith<$Res> {
  factory $ChannelDataCopyWith(
          ChannelData value, $Res Function(ChannelData) then) =
      _$ChannelDataCopyWithImpl<$Res, ChannelData>;
  @useResult
  $Res call(
      {String id,
      String channelName,
      String channelDescription,
      String channelUrl,
      String thumbnailUrl,
      int subscriberCount,
      int videoCount,
      List<VideoData> videos,
      String section,
      bool isLiked});
}

/// @nodoc
class _$ChannelDataCopyWithImpl<$Res, $Val extends ChannelData>
    implements $ChannelDataCopyWith<$Res> {
  _$ChannelDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ChannelData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? channelName = null,
    Object? channelDescription = null,
    Object? channelUrl = null,
    Object? thumbnailUrl = null,
    Object? subscriberCount = null,
    Object? videoCount = null,
    Object? videos = null,
    Object? section = null,
    Object? isLiked = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      channelDescription: null == channelDescription
          ? _value.channelDescription
          : channelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      channelUrl: null == channelUrl
          ? _value.channelUrl
          : channelUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      subscriberCount: null == subscriberCount
          ? _value.subscriberCount
          : subscriberCount // ignore: cast_nullable_to_non_nullable
              as int,
      videoCount: null == videoCount
          ? _value.videoCount
          : videoCount // ignore: cast_nullable_to_non_nullable
              as int,
      videos: null == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<VideoData>,
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
abstract class _$$ChannelDataImplCopyWith<$Res>
    implements $ChannelDataCopyWith<$Res> {
  factory _$$ChannelDataImplCopyWith(
          _$ChannelDataImpl value, $Res Function(_$ChannelDataImpl) then) =
      __$$ChannelDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String channelName,
      String channelDescription,
      String channelUrl,
      String thumbnailUrl,
      int subscriberCount,
      int videoCount,
      List<VideoData> videos,
      String section,
      bool isLiked});
}

/// @nodoc
class __$$ChannelDataImplCopyWithImpl<$Res>
    extends _$ChannelDataCopyWithImpl<$Res, _$ChannelDataImpl>
    implements _$$ChannelDataImplCopyWith<$Res> {
  __$$ChannelDataImplCopyWithImpl(
      _$ChannelDataImpl _value, $Res Function(_$ChannelDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ChannelData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? channelName = null,
    Object? channelDescription = null,
    Object? channelUrl = null,
    Object? thumbnailUrl = null,
    Object? subscriberCount = null,
    Object? videoCount = null,
    Object? videos = null,
    Object? section = null,
    Object? isLiked = null,
  }) {
    return _then(_$ChannelDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      channelName: null == channelName
          ? _value.channelName
          : channelName // ignore: cast_nullable_to_non_nullable
              as String,
      channelDescription: null == channelDescription
          ? _value.channelDescription
          : channelDescription // ignore: cast_nullable_to_non_nullable
              as String,
      channelUrl: null == channelUrl
          ? _value.channelUrl
          : channelUrl // ignore: cast_nullable_to_non_nullable
              as String,
      thumbnailUrl: null == thumbnailUrl
          ? _value.thumbnailUrl
          : thumbnailUrl // ignore: cast_nullable_to_non_nullable
              as String,
      subscriberCount: null == subscriberCount
          ? _value.subscriberCount
          : subscriberCount // ignore: cast_nullable_to_non_nullable
              as int,
      videoCount: null == videoCount
          ? _value.videoCount
          : videoCount // ignore: cast_nullable_to_non_nullable
              as int,
      videos: null == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<VideoData>,
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
class _$ChannelDataImpl implements _ChannelData {
  const _$ChannelDataImpl(
      {this.id = "",
      this.channelName = "",
      this.channelDescription = "",
      this.channelUrl = "",
      this.thumbnailUrl = "",
      this.subscriberCount = 0,
      this.videoCount = 0,
      final List<VideoData> videos = const <VideoData>[],
      this.section = "",
      this.isLiked = false})
      : _videos = videos;

  factory _$ChannelDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChannelDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String channelName;
  @override
  @JsonKey()
  final String channelDescription;
  @override
  @JsonKey()
  final String channelUrl;
  @override
  @JsonKey()
  final String thumbnailUrl;
  @override
  @JsonKey()
  final int subscriberCount;
  @override
  @JsonKey()
  final int videoCount;
  final List<VideoData> _videos;
  @override
  @JsonKey()
  List<VideoData> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

// 리스트 타입으로 수정
  @override
  @JsonKey()
  final String section;
  @override
  @JsonKey()
  final bool isLiked;

  @override
  String toString() {
    return 'ChannelData(id: $id, channelName: $channelName, channelDescription: $channelDescription, channelUrl: $channelUrl, thumbnailUrl: $thumbnailUrl, subscriberCount: $subscriberCount, videoCount: $videoCount, videos: $videos, section: $section, isLiked: $isLiked)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChannelDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.channelName, channelName) ||
                other.channelName == channelName) &&
            (identical(other.channelDescription, channelDescription) ||
                other.channelDescription == channelDescription) &&
            (identical(other.channelUrl, channelUrl) ||
                other.channelUrl == channelUrl) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.subscriberCount, subscriberCount) ||
                other.subscriberCount == subscriberCount) &&
            (identical(other.videoCount, videoCount) ||
                other.videoCount == videoCount) &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            (identical(other.section, section) || other.section == section) &&
            (identical(other.isLiked, isLiked) || other.isLiked == isLiked));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      channelName,
      channelDescription,
      channelUrl,
      thumbnailUrl,
      subscriberCount,
      videoCount,
      const DeepCollectionEquality().hash(_videos),
      section,
      isLiked);

  /// Create a copy of ChannelData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ChannelDataImplCopyWith<_$ChannelDataImpl> get copyWith =>
      __$$ChannelDataImplCopyWithImpl<_$ChannelDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChannelDataImplToJson(
      this,
    );
  }
}

abstract class _ChannelData implements ChannelData {
  const factory _ChannelData(
      {final String id,
      final String channelName,
      final String channelDescription,
      final String channelUrl,
      final String thumbnailUrl,
      final int subscriberCount,
      final int videoCount,
      final List<VideoData> videos,
      final String section,
      final bool isLiked}) = _$ChannelDataImpl;

  factory _ChannelData.fromJson(Map<String, dynamic> json) =
      _$ChannelDataImpl.fromJson;

  @override
  String get id;
  @override
  String get channelName;
  @override
  String get channelDescription;
  @override
  String get channelUrl;
  @override
  String get thumbnailUrl;
  @override
  int get subscriberCount;
  @override
  int get videoCount;
  @override
  List<VideoData> get videos; // 리스트 타입으로 수정
  @override
  String get section;
  @override
  bool get isLiked;

  /// Create a copy of ChannelData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ChannelDataImplCopyWith<_$ChannelDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
