// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipeData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecipeDataImpl _$$RecipeDataImplFromJson(Map<String, dynamic> json) =>
    _$RecipeDataImpl(
      video_id: json['video_id'] as String? ?? "",
      description: json['description'] as String? ?? "",
      ingredients: (json['ingredients'] as List<dynamic>?)
              ?.map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((e) => Equipment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      level: (json['level'] as num?)?.toInt() ?? 0,
      cookingTime: json['cooking_time'] as String? ?? "",
      cookingMethods: (json['cooking_methods'] as List<dynamic>?)
              ?.map((e) => CookingMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      tip_knowhow: json['tip_knowhow'] as String? ?? "",
      finishing: json['finishing'] as String? ?? "",
    );

Map<String, dynamic> _$$RecipeDataImplToJson(_$RecipeDataImpl instance) =>
    <String, dynamic>{
      'video_id': instance.video_id,
      'description': instance.description,
      'ingredients': instance.ingredients,
      'equipment': instance.equipment,
      'level': instance.level,
      'cooking_time': instance.cookingTime,
      'cooking_methods': instance.cookingMethods,
      'tip_knowhow': instance.tip_knowhow,
      'finishing': instance.finishing,
    };

_$IngredientImpl _$$IngredientImplFromJson(Map<String, dynamic> json) =>
    _$IngredientImpl(
      name: json['name'] as String? ?? "",
      volume: json['volume'] as String? ?? "",
    );

Map<String, dynamic> _$$IngredientImplToJson(_$IngredientImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'volume': instance.volume,
    };

_$EquipmentImpl _$$EquipmentImplFromJson(Map<String, dynamic> json) =>
    _$EquipmentImpl(
      name: json['name'] as String? ?? "",
    );

Map<String, dynamic> _$$EquipmentImplToJson(_$EquipmentImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
    };

_$CookingMethodImpl _$$CookingMethodImplFromJson(Map<String, dynamic> json) =>
    _$CookingMethodImpl(
      title: json['title'] as String? ?? "",
      time: json['time'] as String? ?? "",
      description: json['description'] as String? ?? "",
      step: (json['step'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$CookingMethodImplToJson(_$CookingMethodImpl instance) =>
    <String, dynamic>{
      'title': instance.title,
      'time': instance.time,
      'description': instance.description,
      'step': instance.step,
    };
