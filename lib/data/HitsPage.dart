import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cookfluencer/data/videoData.dart';

class HitsPage {
  const HitsPage(this.viodeos, this.pageKey, this.nextPageKey);

  final List<VideoData> viodeos;
  final int pageKey;
  final int? nextPageKey;

  factory HitsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map(VideoData.fromJson).toList();
    final isLastPage = response.page >= response.nbPages;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsPage(items, response.page, nextPageKey);
  }
}
