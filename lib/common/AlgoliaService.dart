import 'package:algolia_helper_flutter/algolia_helper_flutter.dart';
import 'package:cookfluencer/data/HitsChannelsPage.dart';
import 'package:cookfluencer/data/HitsVideosPage.dart';
import 'package:cookfluencer/data/videoData.dart';

class AlgoliaService {
  // AlgoliaService에서 사용할 인스턴스 변수들
  final HitsSearcher _titleSearcher;
  final HitsSearcher _channelSearcher;

  AlgoliaService()
      : _titleSearcher = HitsSearcher(
          applicationID: 'MC84CR9U8O',
          apiKey: 'ecef53cb69da08b3e4f77e92cc600eb1',
          indexName: 'title',
        ),
        _channelSearcher = HitsSearcher(
          applicationID: 'MC84CR9U8O',
          apiKey: 'ecef53cb69da08b3e4f77e92cc600eb1',
          indexName: 'channel_name',
        );

  // 타이틀에 대한 검색 페이지 스트림 반환
  Stream<HitsVideosPage> searchTitle(String query, int pageKey) {
    _titleSearcher.applyState(
          (state) => state.copyWith(
        query: query,
        page: pageKey,
        hitsPerPage: 20, // 한 페이지에 표시할 항목 수\\
      ),
    );
    return _titleSearcher.responses.map(HitsVideosPage.fromResponse);
  }


  // 채널 이름에 대한 검색 페이지 스트림 반환
  Stream<HitsChannelsPage> searchChannel(String query, int pageKey) {
    _channelSearcher.applyState(
          (state) => state.copyWith(
        query: query,
        page: pageKey,
        hitsPerPage: 20, // 한 페이지에 표시할 항목 수
      ),
    );

    return _channelSearcher.responses.map(HitsChannelsPage.fromResponse);
  }

// 최신순 또는 인기순 정렬이 적용된 타이틀 검색
  Stream<HitsVideosPage> searchTitleFilter(String query, int pageKey, String sortBy) {
    try {
      final String indexName = sortBy == 'created_at DESC'
          ? 'title_by_created_at_desc' // 최신순
          : 'title_by_popularity_desc'; // 인기순

      final HitsSearcher searcher = HitsSearcher(
        applicationID: 'MC84CR9U8O',
        apiKey: 'ecef53cb69da08b3e4f77e92cc600eb1',
        indexName: indexName,
      );

      searcher.applyState(
            (state) => state.copyWith(
          query: query,
          page: pageKey,
          hitsPerPage: 20,
        ),
      );

      return searcher.responses.map(HitsVideosPage.fromResponse);
    } catch (e) {
      print("Error in searchTitleFilter: $e");
      rethrow;
    }
  }

  // 최신순 또는 인기순 정렬이 적용된 채널 검색
  Stream<HitsChannelsPage> searchChannelFilter(String query, int pageKey, String sortBy) {
    final String indexName = sortBy == 'created_at DESC'
        ? 'channel_name_by_created_at_desc' // 최신순
        : 'channel_name_by_popularity_desc'; // 인기순

    // Replica Index 사용
    final HitsSearcher searcher = HitsSearcher(
      applicationID: 'MC84CR9U8O',
      apiKey: 'ecef53cb69da08b3e4f77e92cc600eb1',
      indexName: indexName,
    );

    searcher.applyState(
          (state) => state.copyWith(
        query: query,
        page: pageKey,
        hitsPerPage: 20,
      ),
    );

    return searcher.responses.map(HitsChannelsPage.fromResponse);
  }
}
