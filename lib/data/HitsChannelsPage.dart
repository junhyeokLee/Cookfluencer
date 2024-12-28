import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cookfluencer/data/channelData.dart';

class HitsChannelsPage {
  const HitsChannelsPage(this.channels, this.pageKey, this.nextPageKey);

  final List<ChannelData> channels;
  final int pageKey;
  final int? nextPageKey;

  factory HitsChannelsPage.fromResponse(SearchResponse response) {
    final items = response.hits.map((hit) {
      if (hit is Map<String, dynamic>) {
        return ChannelData.fromJson(hit);
      } else {
        throw Exception("Unexpected hit format: ${hit.runtimeType}");
      }
    }).toList();
    final isLastPage = response.page >= response.nbPages - 1;
    final nextPageKey = isLastPage ? null : response.page + 1;
    return HitsChannelsPage(items, response.page, nextPageKey);
  }

}