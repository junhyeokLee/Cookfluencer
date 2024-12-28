import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cookfluencer/data/videoData.dart';

class HitsVideosPage {
  const HitsVideosPage(this.videos, this.pageKey, this.nextPageKey);

  final List<VideoData> videos;
  final int pageKey;
  final int? nextPageKey;

  factory HitsVideosPage.fromResponse(SearchResponse response) {
    final items = response.hits.map((hit) {
      if (hit is Map<String, dynamic>) {
        return VideoData.fromJson(hit);
      } else {
        throw Exception("Unexpected hit format: ${hit.runtimeType}");
      }
    }).toList();
    final isLastPage = response.page >= response.nbPages - 1;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsVideosPage(items, response.page, nextPageKey);
  }
}

