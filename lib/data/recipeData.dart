import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipeData.freezed.dart';
part 'recipeData.g.dart';

@freezed
class RecipeData with _$RecipeData { // 이름 수정
  const factory RecipeData({
    @Default("") String video_id,
    @JsonKey(name: 'description') @Default("") String description,
    @JsonKey(name: 'ingredients') @Default([]) List<Ingredient> ingredients,
    @JsonKey(name: 'equipment') @Default([]) List<Equipment> equipment,
    @Default(0) int level,
    @JsonKey(name: 'cooking_time') @Default("") String cookingTime,
    @JsonKey(name: 'cooking_methods') @Default([]) List<CookingMethod> cookingMethods,
    @JsonKey(name: 'tip_knowhow') @Default("") String tip_knowhow,
    @JsonKey(name: 'finishing') @Default("") String finishing,
  }) = _RecipeData;

  factory RecipeData.fromJson(Map<String, dynamic> json) => _$RecipeDataFromJson(json);
}

@freezed
class Ingredient with _$Ingredient {
  const factory Ingredient({
    @Default("") String name,
    @Default("") String volume,
  }) = _Ingredient;

  factory Ingredient.fromJson(Map<String, dynamic> json) => _$IngredientFromJson(json);
}

@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    @Default("") String name,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) => _$EquipmentFromJson(json);
}

@freezed
class CookingMethod with _$CookingMethod {
  const factory CookingMethod({
    @Default("") String title,
    @Default("") String time,
    @Default("") String description,
    @Default(0) int step,
  }) = _CookingMethod;

  factory CookingMethod.fromJson(Map<String, dynamic> json) => _$CookingMethodFromJson(json);
}


