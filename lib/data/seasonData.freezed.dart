// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'seasonData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SeasonData _$SeasonDataFromJson(Map<String, dynamic> json) {
  return _SeasonData.fromJson(json);
}

/// @nodoc
mixin _$SeasonData {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get sub_title => throw _privateConstructorUsedError;
  String get image => throw _privateConstructorUsedError;
  List<VideoData> get videos => throw _privateConstructorUsedError;

  /// Serializes this SeasonData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SeasonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SeasonDataCopyWith<SeasonData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonDataCopyWith<$Res> {
  factory $SeasonDataCopyWith(
          SeasonData value, $Res Function(SeasonData) then) =
      _$SeasonDataCopyWithImpl<$Res, SeasonData>;
  @useResult
  $Res call(
      {String id,
      String title,
      String sub_title,
      String image,
      List<VideoData> videos});
}

/// @nodoc
class _$SeasonDataCopyWithImpl<$Res, $Val extends SeasonData>
    implements $SeasonDataCopyWith<$Res> {
  _$SeasonDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SeasonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sub_title = null,
    Object? image = null,
    Object? videos = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sub_title: null == sub_title
          ? _value.sub_title
          : sub_title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      videos: null == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<VideoData>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SeasonDataImplCopyWith<$Res>
    implements $SeasonDataCopyWith<$Res> {
  factory _$$SeasonDataImplCopyWith(
          _$SeasonDataImpl value, $Res Function(_$SeasonDataImpl) then) =
      __$$SeasonDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String sub_title,
      String image,
      List<VideoData> videos});
}

/// @nodoc
class __$$SeasonDataImplCopyWithImpl<$Res>
    extends _$SeasonDataCopyWithImpl<$Res, _$SeasonDataImpl>
    implements _$$SeasonDataImplCopyWith<$Res> {
  __$$SeasonDataImplCopyWithImpl(
      _$SeasonDataImpl _value, $Res Function(_$SeasonDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of SeasonData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? sub_title = null,
    Object? image = null,
    Object? videos = null,
  }) {
    return _then(_$SeasonDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      sub_title: null == sub_title
          ? _value.sub_title
          : sub_title // ignore: cast_nullable_to_non_nullable
              as String,
      image: null == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String,
      videos: null == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<VideoData>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SeasonDataImpl implements _SeasonData {
  const _$SeasonDataImpl(
      {this.id = "",
      this.title = "",
      this.sub_title = "",
      this.image = "",
      final List<VideoData> videos = const <VideoData>[]})
      : _videos = videos;

  factory _$SeasonDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$SeasonDataImplFromJson(json);

  @override
  @JsonKey()
  final String id;
  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String sub_title;
  @override
  @JsonKey()
  final String image;
  final List<VideoData> _videos;
  @override
  @JsonKey()
  List<VideoData> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  @override
  String toString() {
    return 'SeasonData(id: $id, title: $title, sub_title: $sub_title, image: $image, videos: $videos)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.sub_title, sub_title) ||
                other.sub_title == sub_title) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality().equals(other._videos, _videos));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, title, sub_title, image,
      const DeepCollectionEquality().hash(_videos));

  /// Create a copy of SeasonData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonDataImplCopyWith<_$SeasonDataImpl> get copyWith =>
      __$$SeasonDataImplCopyWithImpl<_$SeasonDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SeasonDataImplToJson(
      this,
    );
  }
}

abstract class _SeasonData implements SeasonData {
  const factory _SeasonData(
      {final String id,
      final String title,
      final String sub_title,
      final String image,
      final List<VideoData> videos}) = _$SeasonDataImpl;

  factory _SeasonData.fromJson(Map<String, dynamic> json) =
      _$SeasonDataImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get sub_title;
  @override
  String get image;
  @override
  List<VideoData> get videos;

  /// Create a copy of SeasonData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SeasonDataImplCopyWith<_$SeasonDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
