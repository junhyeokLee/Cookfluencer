import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cookfluencer/data/videoData.dart';

class HitsVideosPage {
  const HitsVideosPage(this.videos, this.pageKey, this.nextPageKey);

  final List<VideoData> videos;
  final int pageKey;
  final int? nextPageKey;

  // ✅ Algolia 검색 결과를 받아서 VideosPage로 변환 + 정렬 적용
  factory HitsVideosPage.fromResponse(SearchResponse response, {String? sortBy}) {
    final items = response.hits.map((hit) {
      if (hit is Map<String, dynamic>) {
        return VideoData.fromJson(hit);
      } else {
        throw Exception("Unexpected hit format: ${hit.runtimeType}");
      }
    }).toList();

    // ✅ 최신순 / 인기순 정렬 적용
    if (sortBy == 'upload_date') {
      items.sort((a, b) {
        try {
          final dateA = a.uploadDate != null ? DateTime.parse(a.uploadDate) : DateTime(2000);
          final dateB = b.uploadDate != null ? DateTime.parse(b.uploadDate) : DateTime(2000);
          return dateB.compareTo(dateA); // 최신순 정렬
        } catch (e) {
          print("DateTime parsing error: $e");
          return 0;
        }
      });

    } else if (sortBy == 'view_count') {
      // 비교 없이 바로 내림차순 정렬
      items.sort((a, b) => b.viewCount.compareTo(a.viewCount));  // 인기순 정렬

      // 최신 인기순
      // items.sort((a, b) {
      //   try {
      //     final dateA = a.uploadDate != null ? DateTime.parse(a.uploadDate) : DateTime(2000);
      //     final dateB = b.uploadDate != null ? DateTime.parse(b.uploadDate) : DateTime(2000);
      //     return dateB.compareTo(dateA); // 최신순 정렬
      //   } catch (e) {
      //     print("DateTime parsing error: $e");
      //     return 0;
      //   }
      // });
    }

    final isLastPage = response.page >= response.nbPages - 1;
    final nextPageKey = isLastPage ? null : response.page + 1;

    return HitsVideosPage(items, response.page, nextPageKey);
  }

}
