// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipeData.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

RecipeData _$RecipeDataFromJson(Map<String, dynamic> json) {
  return _RecipeData.fromJson(json);
}

/// @nodoc
mixin _$RecipeData {
  String get video_id => throw _privateConstructorUsedError;
  @JsonKey(name: 'description')
  String get description => throw _privateConstructorUsedError;
  @JsonKey(name: 'ingredients')
  List<Ingredient> get ingredients => throw _privateConstructorUsedError;
  @JsonKey(name: 'equipment')
  List<Equipment> get equipment => throw _privateConstructorUsedError;
  int get level => throw _privateConstructorUsedError;
  @JsonKey(name: 'cooking_time')
  String get cookingTime => throw _privateConstructorUsedError;
  @JsonKey(name: 'cooking_methods')
  List<CookingMethod> get cookingMethods => throw _privateConstructorUsedError;
  @JsonKey(name: 'tip_knowhow')
  String get tip_knowhow => throw _privateConstructorUsedError;
  @JsonKey(name: 'finishing')
  String get finishing => throw _privateConstructorUsedError;

  /// Serializes this RecipeData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of RecipeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $RecipeDataCopyWith<RecipeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeDataCopyWith<$Res> {
  factory $RecipeDataCopyWith(
          RecipeData value, $Res Function(RecipeData) then) =
      _$RecipeDataCopyWithImpl<$Res, RecipeData>;
  @useResult
  $Res call(
      {String video_id,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'ingredients') List<Ingredient> ingredients,
      @JsonKey(name: 'equipment') List<Equipment> equipment,
      int level,
      @JsonKey(name: 'cooking_time') String cookingTime,
      @JsonKey(name: 'cooking_methods') List<CookingMethod> cookingMethods,
      @JsonKey(name: 'tip_knowhow') String tip_knowhow,
      @JsonKey(name: 'finishing') String finishing});
}

/// @nodoc
class _$RecipeDataCopyWithImpl<$Res, $Val extends RecipeData>
    implements $RecipeDataCopyWith<$Res> {
  _$RecipeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of RecipeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? video_id = null,
    Object? description = null,
    Object? ingredients = null,
    Object? equipment = null,
    Object? level = null,
    Object? cookingTime = null,
    Object? cookingMethods = null,
    Object? tip_knowhow = null,
    Object? finishing = null,
  }) {
    return _then(_value.copyWith(
      video_id: null == video_id
          ? _value.video_id
          : video_id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      equipment: null == equipment
          ? _value.equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<Equipment>,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      cookingTime: null == cookingTime
          ? _value.cookingTime
          : cookingTime // ignore: cast_nullable_to_non_nullable
              as String,
      cookingMethods: null == cookingMethods
          ? _value.cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<CookingMethod>,
      tip_knowhow: null == tip_knowhow
          ? _value.tip_knowhow
          : tip_knowhow // ignore: cast_nullable_to_non_nullable
              as String,
      finishing: null == finishing
          ? _value.finishing
          : finishing // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeDataImplCopyWith<$Res>
    implements $RecipeDataCopyWith<$Res> {
  factory _$$RecipeDataImplCopyWith(
          _$RecipeDataImpl value, $Res Function(_$RecipeDataImpl) then) =
      __$$RecipeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String video_id,
      @JsonKey(name: 'description') String description,
      @JsonKey(name: 'ingredients') List<Ingredient> ingredients,
      @JsonKey(name: 'equipment') List<Equipment> equipment,
      int level,
      @JsonKey(name: 'cooking_time') String cookingTime,
      @JsonKey(name: 'cooking_methods') List<CookingMethod> cookingMethods,
      @JsonKey(name: 'tip_knowhow') String tip_knowhow,
      @JsonKey(name: 'finishing') String finishing});
}

/// @nodoc
class __$$RecipeDataImplCopyWithImpl<$Res>
    extends _$RecipeDataCopyWithImpl<$Res, _$RecipeDataImpl>
    implements _$$RecipeDataImplCopyWith<$Res> {
  __$$RecipeDataImplCopyWithImpl(
      _$RecipeDataImpl _value, $Res Function(_$RecipeDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of RecipeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? video_id = null,
    Object? description = null,
    Object? ingredients = null,
    Object? equipment = null,
    Object? level = null,
    Object? cookingTime = null,
    Object? cookingMethods = null,
    Object? tip_knowhow = null,
    Object? finishing = null,
  }) {
    return _then(_$RecipeDataImpl(
      video_id: null == video_id
          ? _value.video_id
          : video_id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ingredients: null == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>,
      equipment: null == equipment
          ? _value._equipment
          : equipment // ignore: cast_nullable_to_non_nullable
              as List<Equipment>,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      cookingTime: null == cookingTime
          ? _value.cookingTime
          : cookingTime // ignore: cast_nullable_to_non_nullable
              as String,
      cookingMethods: null == cookingMethods
          ? _value._cookingMethods
          : cookingMethods // ignore: cast_nullable_to_non_nullable
              as List<CookingMethod>,
      tip_knowhow: null == tip_knowhow
          ? _value.tip_knowhow
          : tip_knowhow // ignore: cast_nullable_to_non_nullable
              as String,
      finishing: null == finishing
          ? _value.finishing
          : finishing // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$RecipeDataImpl implements _RecipeData {
  const _$RecipeDataImpl(
      {this.video_id = "",
      @JsonKey(name: 'description') this.description = "",
      @JsonKey(name: 'ingredients')
      final List<Ingredient> ingredients = const [],
      @JsonKey(name: 'equipment') final List<Equipment> equipment = const [],
      this.level = 0,
      @JsonKey(name: 'cooking_time') this.cookingTime = "",
      @JsonKey(name: 'cooking_methods')
      final List<CookingMethod> cookingMethods = const [],
      @JsonKey(name: 'tip_knowhow') this.tip_knowhow = "",
      @JsonKey(name: 'finishing') this.finishing = ""})
      : _ingredients = ingredients,
        _equipment = equipment,
        _cookingMethods = cookingMethods;

  factory _$RecipeDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$RecipeDataImplFromJson(json);

  @override
  @JsonKey()
  final String video_id;
  @override
  @JsonKey(name: 'description')
  final String description;
  final List<Ingredient> _ingredients;
  @override
  @JsonKey(name: 'ingredients')
  List<Ingredient> get ingredients {
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_ingredients);
  }

  final List<Equipment> _equipment;
  @override
  @JsonKey(name: 'equipment')
  List<Equipment> get equipment {
    if (_equipment is EqualUnmodifiableListView) return _equipment;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_equipment);
  }

  @override
  @JsonKey()
  final int level;
  @override
  @JsonKey(name: 'cooking_time')
  final String cookingTime;
  final List<CookingMethod> _cookingMethods;
  @override
  @JsonKey(name: 'cooking_methods')
  List<CookingMethod> get cookingMethods {
    if (_cookingMethods is EqualUnmodifiableListView) return _cookingMethods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cookingMethods);
  }

  @override
  @JsonKey(name: 'tip_knowhow')
  final String tip_knowhow;
  @override
  @JsonKey(name: 'finishing')
  final String finishing;

  @override
  String toString() {
    return 'RecipeData(video_id: $video_id, description: $description, ingredients: $ingredients, equipment: $equipment, level: $level, cookingTime: $cookingTime, cookingMethods: $cookingMethods, tip_knowhow: $tip_knowhow, finishing: $finishing)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeDataImpl &&
            (identical(other.video_id, video_id) ||
                other.video_id == video_id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            const DeepCollectionEquality()
                .equals(other._equipment, _equipment) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.cookingTime, cookingTime) ||
                other.cookingTime == cookingTime) &&
            const DeepCollectionEquality()
                .equals(other._cookingMethods, _cookingMethods) &&
            (identical(other.tip_knowhow, tip_knowhow) ||
                other.tip_knowhow == tip_knowhow) &&
            (identical(other.finishing, finishing) ||
                other.finishing == finishing));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      video_id,
      description,
      const DeepCollectionEquality().hash(_ingredients),
      const DeepCollectionEquality().hash(_equipment),
      level,
      cookingTime,
      const DeepCollectionEquality().hash(_cookingMethods),
      tip_knowhow,
      finishing);

  /// Create a copy of RecipeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeDataImplCopyWith<_$RecipeDataImpl> get copyWith =>
      __$$RecipeDataImplCopyWithImpl<_$RecipeDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$RecipeDataImplToJson(
      this,
    );
  }
}

abstract class _RecipeData implements RecipeData {
  const factory _RecipeData(
      {final String video_id,
      @JsonKey(name: 'description') final String description,
      @JsonKey(name: 'ingredients') final List<Ingredient> ingredients,
      @JsonKey(name: 'equipment') final List<Equipment> equipment,
      final int level,
      @JsonKey(name: 'cooking_time') final String cookingTime,
      @JsonKey(name: 'cooking_methods')
      final List<CookingMethod> cookingMethods,
      @JsonKey(name: 'tip_knowhow') final String tip_knowhow,
      @JsonKey(name: 'finishing') final String finishing}) = _$RecipeDataImpl;

  factory _RecipeData.fromJson(Map<String, dynamic> json) =
      _$RecipeDataImpl.fromJson;

  @override
  String get video_id;
  @override
  @JsonKey(name: 'description')
  String get description;
  @override
  @JsonKey(name: 'ingredients')
  List<Ingredient> get ingredients;
  @override
  @JsonKey(name: 'equipment')
  List<Equipment> get equipment;
  @override
  int get level;
  @override
  @JsonKey(name: 'cooking_time')
  String get cookingTime;
  @override
  @JsonKey(name: 'cooking_methods')
  List<CookingMethod> get cookingMethods;
  @override
  @JsonKey(name: 'tip_knowhow')
  String get tip_knowhow;
  @override
  @JsonKey(name: 'finishing')
  String get finishing;

  /// Create a copy of RecipeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$RecipeDataImplCopyWith<_$RecipeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Ingredient _$IngredientFromJson(Map<String, dynamic> json) {
  return _Ingredient.fromJson(json);
}

/// @nodoc
mixin _$Ingredient {
  String get name => throw _privateConstructorUsedError;
  String get volume => throw _privateConstructorUsedError;

  /// Serializes this Ingredient to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $IngredientCopyWith<Ingredient> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $IngredientCopyWith<$Res> {
  factory $IngredientCopyWith(
          Ingredient value, $Res Function(Ingredient) then) =
      _$IngredientCopyWithImpl<$Res, Ingredient>;
  @useResult
  $Res call({String name, String volume});
}

/// @nodoc
class _$IngredientCopyWithImpl<$Res, $Val extends Ingredient>
    implements $IngredientCopyWith<$Res> {
  _$IngredientCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? volume = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$IngredientImplCopyWith<$Res>
    implements $IngredientCopyWith<$Res> {
  factory _$$IngredientImplCopyWith(
          _$IngredientImpl value, $Res Function(_$IngredientImpl) then) =
      __$$IngredientImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name, String volume});
}

/// @nodoc
class __$$IngredientImplCopyWithImpl<$Res>
    extends _$IngredientCopyWithImpl<$Res, _$IngredientImpl>
    implements _$$IngredientImplCopyWith<$Res> {
  __$$IngredientImplCopyWithImpl(
      _$IngredientImpl _value, $Res Function(_$IngredientImpl) _then)
      : super(_value, _then);

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? volume = null,
  }) {
    return _then(_$IngredientImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      volume: null == volume
          ? _value.volume
          : volume // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$IngredientImpl implements _Ingredient {
  const _$IngredientImpl({this.name = "", this.volume = ""});

  factory _$IngredientImpl.fromJson(Map<String, dynamic> json) =>
      _$$IngredientImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String volume;

  @override
  String toString() {
    return 'Ingredient(name: $name, volume: $volume)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$IngredientImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.volume, volume) || other.volume == volume));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name, volume);

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$IngredientImplCopyWith<_$IngredientImpl> get copyWith =>
      __$$IngredientImplCopyWithImpl<_$IngredientImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$IngredientImplToJson(
      this,
    );
  }
}

abstract class _Ingredient implements Ingredient {
  const factory _Ingredient({final String name, final String volume}) =
      _$IngredientImpl;

  factory _Ingredient.fromJson(Map<String, dynamic> json) =
      _$IngredientImpl.fromJson;

  @override
  String get name;
  @override
  String get volume;

  /// Create a copy of Ingredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$IngredientImplCopyWith<_$IngredientImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Equipment _$EquipmentFromJson(Map<String, dynamic> json) {
  return _Equipment.fromJson(json);
}

/// @nodoc
mixin _$Equipment {
  String get name => throw _privateConstructorUsedError;

  /// Serializes this Equipment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $EquipmentCopyWith<Equipment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EquipmentCopyWith<$Res> {
  factory $EquipmentCopyWith(Equipment value, $Res Function(Equipment) then) =
      _$EquipmentCopyWithImpl<$Res, Equipment>;
  @useResult
  $Res call({String name});
}

/// @nodoc
class _$EquipmentCopyWithImpl<$Res, $Val extends Equipment>
    implements $EquipmentCopyWith<$Res> {
  _$EquipmentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EquipmentImplCopyWith<$Res>
    implements $EquipmentCopyWith<$Res> {
  factory _$$EquipmentImplCopyWith(
          _$EquipmentImpl value, $Res Function(_$EquipmentImpl) then) =
      __$$EquipmentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String name});
}

/// @nodoc
class __$$EquipmentImplCopyWithImpl<$Res>
    extends _$EquipmentCopyWithImpl<$Res, _$EquipmentImpl>
    implements _$$EquipmentImplCopyWith<$Res> {
  __$$EquipmentImplCopyWithImpl(
      _$EquipmentImpl _value, $Res Function(_$EquipmentImpl) _then)
      : super(_value, _then);

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
  }) {
    return _then(_$EquipmentImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$EquipmentImpl implements _Equipment {
  const _$EquipmentImpl({this.name = ""});

  factory _$EquipmentImpl.fromJson(Map<String, dynamic> json) =>
      _$$EquipmentImplFromJson(json);

  @override
  @JsonKey()
  final String name;

  @override
  String toString() {
    return 'Equipment(name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EquipmentImpl &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, name);

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      __$$EquipmentImplCopyWithImpl<_$EquipmentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$EquipmentImplToJson(
      this,
    );
  }
}

abstract class _Equipment implements Equipment {
  const factory _Equipment({final String name}) = _$EquipmentImpl;

  factory _Equipment.fromJson(Map<String, dynamic> json) =
      _$EquipmentImpl.fromJson;

  @override
  String get name;

  /// Create a copy of Equipment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$EquipmentImplCopyWith<_$EquipmentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CookingMethod _$CookingMethodFromJson(Map<String, dynamic> json) {
  return _CookingMethod.fromJson(json);
}

/// @nodoc
mixin _$CookingMethod {
  String get title => throw _privateConstructorUsedError;
  String get time => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get step => throw _privateConstructorUsedError;

  /// Serializes this CookingMethod to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CookingMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CookingMethodCopyWith<CookingMethod> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CookingMethodCopyWith<$Res> {
  factory $CookingMethodCopyWith(
          CookingMethod value, $Res Function(CookingMethod) then) =
      _$CookingMethodCopyWithImpl<$Res, CookingMethod>;
  @useResult
  $Res call({String title, String time, String description, int step});
}

/// @nodoc
class _$CookingMethodCopyWithImpl<$Res, $Val extends CookingMethod>
    implements $CookingMethodCopyWith<$Res> {
  _$CookingMethodCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CookingMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? description = null,
    Object? step = null,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CookingMethodImplCopyWith<$Res>
    implements $CookingMethodCopyWith<$Res> {
  factory _$$CookingMethodImplCopyWith(
          _$CookingMethodImpl value, $Res Function(_$CookingMethodImpl) then) =
      __$$CookingMethodImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String time, String description, int step});
}

/// @nodoc
class __$$CookingMethodImplCopyWithImpl<$Res>
    extends _$CookingMethodCopyWithImpl<$Res, _$CookingMethodImpl>
    implements _$$CookingMethodImplCopyWith<$Res> {
  __$$CookingMethodImplCopyWithImpl(
      _$CookingMethodImpl _value, $Res Function(_$CookingMethodImpl) _then)
      : super(_value, _then);

  /// Create a copy of CookingMethod
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? time = null,
    Object? description = null,
    Object? step = null,
  }) {
    return _then(_$CookingMethodImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      step: null == step
          ? _value.step
          : step // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CookingMethodImpl implements _CookingMethod {
  const _$CookingMethodImpl(
      {this.title = "", this.time = "", this.description = "", this.step = 0});

  factory _$CookingMethodImpl.fromJson(Map<String, dynamic> json) =>
      _$$CookingMethodImplFromJson(json);

  @override
  @JsonKey()
  final String title;
  @override
  @JsonKey()
  final String time;
  @override
  @JsonKey()
  final String description;
  @override
  @JsonKey()
  final int step;

  @override
  String toString() {
    return 'CookingMethod(title: $title, time: $time, description: $description, step: $step)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CookingMethodImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.step, step) || other.step == step));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, time, description, step);

  /// Create a copy of CookingMethod
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CookingMethodImplCopyWith<_$CookingMethodImpl> get copyWith =>
      __$$CookingMethodImplCopyWithImpl<_$CookingMethodImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CookingMethodImplToJson(
      this,
    );
  }
}

abstract class _CookingMethod implements CookingMethod {
  const factory _CookingMethod(
      {final String title,
      final String time,
      final String description,
      final int step}) = _$CookingMethodImpl;

  factory _CookingMethod.fromJson(Map<String, dynamic> json) =
      _$CookingMethodImpl.fromJson;

  @override
  String get title;
  @override
  String get time;
  @override
  String get description;
  @override
  int get step;

  /// Create a copy of CookingMethod
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CookingMethodImplCopyWith<_$CookingMethodImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
