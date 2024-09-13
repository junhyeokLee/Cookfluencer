
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/home/RecommendChannel.dart';
import 'package:cookfluencer/ui/widget/home/RecommendKeyword.dart';
import 'package:cookfluencer/ui/widget/home/RecommendRecipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final recommendChannelsAsyncValue = ref.watch(recommendChannelsProvider);
    final recommendVideoListAsyncValue = ref.watch(recommendVideosProvider);
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 0, title: Text('')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // 추천 비디오 리스트
                  recommendVideoListAsyncValue.when(
                    data: (videoSnapshots) {
                      // QueryDocumentSnapshot에서 Map<String, dynamic>으로 변환
                      List<Map<String, dynamic>> videos = videoSnapshots
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();
                      return RecommendRecipe(recommendVideoListAsyncValue: videos);
                    },
                    loading: () => CircularLoading(),
                    error: (error, stackTrace) => ErrorMessage(message: '${error}')
                  ),
                  // 추천 채널 리스트
                  recommendChannelsAsyncValue.when(
                    data: (channelsSnapshots) {
                      // QueryDocumentSnapshot에서 Map<String, dynamic>으로 변환
                      List<Map<String, dynamic>> channels = channelsSnapshots
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();
                      return RecommendChannel(recommendChannelsListAsyncValue: channels);
                    },
                    loading: () => CircularLoading(),
                    error: (error, stackTrace) => ErrorMessage(message: '${error}'),
                  ),

                  keywordListAsyncValue.when(
                    data: (keywords) {
                      // QueryDocumentSnapshot에서 Map<String, dynamic>으로 변환
                      List<Map<String, dynamic>> keywordList = keywords
                          .map((doc) => doc.data() as Map<String, dynamic>)
                          .toList();
                      return RecommendKeyword(keywordListAsyncValue: keywordList);
                    },
                    loading: () => CircularLoading(),
                    error: (error, stackTrace) => ErrorMessage(message: '${error}'),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }
}