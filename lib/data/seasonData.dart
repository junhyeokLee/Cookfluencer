import 'package:cookfluencer/data/videoData.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'seasonData.freezed.dart';
part 'seasonData.g.dart';

@freezed
class SeasonData with _$SeasonData {
  const factory SeasonData({
    @Default("") String id,
    @Default("") String title,
    @Default("") String sub_title,
    @Default("") String image,
    @Default(<VideoData>[]) List<VideoData> videos, // 리스트 타입으로 수정
  }) = _SeasonData;

  factory SeasonData.fromJson(Map<String, dynamic> json) => _$SeasonDataFromJson(json);
}
