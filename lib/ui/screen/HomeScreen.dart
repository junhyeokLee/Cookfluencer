import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/SeasonProvider.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:cookfluencer/ui/widget/common/ServiceSuggestions.dart';
import 'package:cookfluencer/ui/widget/home/RecommendChannel.dart';
import 'package:cookfluencer/ui/widget/home/RecommendKeyword.dart';
import 'package:cookfluencer/ui/widget/home/RecommendRecipe.dart';
import 'package:cookfluencer/ui/widget/home/RecommendSeasonRecipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 세 개의 AsyncValue를 한번에 처리
    final recommendChannelsAsyncValue = ref.watch(recommendChannelsProvider);
    final recommendVideoListAsyncValue = ref.watch(recommendVideosProvider);
    final recommendSeasonAsyncValue = ref.watch(seasonListProvider);
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    // 모든 데이터가 로드되는지 확인
    final isLoading = recommendChannelsAsyncValue.isLoading ||
        recommendVideoListAsyncValue.isLoading ||
        keywordListAsyncValue.isLoading;

    final hasError = recommendChannelsAsyncValue.hasError ||
        recommendVideoListAsyncValue.hasError ||
        keywordListAsyncValue.hasError;

    // 에러가 발생한 경우 에러 메시지 처리
    if (hasError) {
      return Scaffold(
        appBar: AppbarWidget(),
        body: Center(
          child: ErrorMessage(
            message: 'An error occurred. Please try again later.',
          ),
        ),
      );
    }

    // 로딩 상태 처리: 세 가지 데이터가 모두 로드될 때까지 하나의 로딩 화면을 보여줌
    if (isLoading) {
      return Scaffold(
        appBar: AppbarWidget(),
        body: Center(
          child: CircularLoading(),
        ),
      );
    }

    // 데이터가 모두 로드되면 보여줄 UI
    final videoSnapshots = recommendVideoListAsyncValue.asData!.value;
    final videos = videoSnapshots
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    final channelsSnapshots = recommendChannelsAsyncValue.asData!.value;
    final channels = channelsSnapshots
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    final seasonSnapshots = recommendSeasonAsyncValue.asData?.value ?? [];
    final season = seasonSnapshots;

    final keywords = keywordListAsyncValue.asData!.value;
    final keywordList = keywords
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    return Scaffold(
      appBar: AppbarWidget(),

      body: SingleChildScrollView(
        child: Column(
          children: [
            // 추천 비디오 리스트
            Container(
              margin: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primaryColor,
              ),
              child: RecommendRecipe(recommendVideoListAsyncValue: videos),
            ),
            // 추천 채널 리스트
            RecommendChannel(recommendChannelsListAsyncValue: channels),
            // 추천 키워드 리스트
            Container(
                margin: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: AppColors.keywordBackground,
                ),
                child: RecommendKeyword(keywordListAsyncValue: keywordList)),

            RecommendSeasonRecipe(recommendSeasonListAsyncValue: season),
            Servicesuggestions(),
          ],
        ),
      ),
    );
  }
}

