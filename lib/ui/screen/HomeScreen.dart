import 'dart:io';

import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/provider/SeasonProvider.dart';
import 'package:cookfluencer/provider/UpdateProvider.dart';
import 'package:cookfluencer/provider/VideoProvider.dart';
import 'package:cookfluencer/ui/widget/AdBannerBottom.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:cookfluencer/ui/widget/common/ServiceSuggestions.dart';
import 'package:cookfluencer/ui/widget/home/RecommendChannel.dart';
import 'package:cookfluencer/ui/widget/home/RecommendKeyword.dart';
import 'package:cookfluencer/ui/widget/home/RecommendRecipe.dart';
import 'package:cookfluencer/ui/widget/home/RecommendSeasonRecipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widget/home/RecentVideo.dart';


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendChannelsAsyncValue = ref.watch(recommendChannelsProvider);
    final recommendVideoListAsyncValue = ref.watch(recommendVideosProvider);
    final recentVideoListAsyncValue = ref.watch(recentVideosProvider);
    final recommendSeasonAsyncValue = ref.watch(seasonListProvider);
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    final isLoading = recommendChannelsAsyncValue.isLoading ||
        recommendVideoListAsyncValue.isLoading ||
        keywordListAsyncValue.isLoading ||
        recommendSeasonAsyncValue.isLoading; // 시즌도 로딩 상태 체크

    final hasError = recommendChannelsAsyncValue.hasError ||
        recommendVideoListAsyncValue.hasError ||
        keywordListAsyncValue.hasError ||
        recommendSeasonAsyncValue.hasError; // 시즌도 에러 상태 체크

    if (hasError) {
      return UpdateChecker(
        child: Scaffold(
          appBar: AppbarWidget(),
          body: Center(
            child: ErrorMessage(
              message: 'An error occurred. Please try again later.',
            ),
          ),
        ),
      );
    }

    if (isLoading) {
      return Scaffold(
        appBar: AppbarWidget(),
        body: Center(
          child: CircularLoading(),
        ),
      );
    }

    // final videoSnapshots = recommendVideoListAsyncValue.asData!.value;
    // final videos = videoSnapshots
    //     .map((doc) => doc as Map<String, dynamic>)
    //     .toList();

    // final seasonSnapshots = recommendSeasonAsyncValue.asData?.value ?? [];
    // final season = seasonSnapshots;

    final videos = recommendVideoListAsyncValue.asData!.value; // 이미 VideoData 타입의 리스트
    final recentVideos = recentVideoListAsyncValue.asData!.value; // 이미 VideoData 타입의 리스트
    final season = recommendSeasonAsyncValue.asData!.value; // 이미 SeasonData 타입의 리스트

    final channelsSnapshots = recommendChannelsAsyncValue.asData!.value;
    final channels = channelsSnapshots
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    final keywords = keywordListAsyncValue.asData!.value;
    final keywordList = keywords
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // AdPopcornSSP.loadInterstitial('118439798', 'V247cLQwngSgnN4');
    //
    // AdPopcornSSP.interstitialAdLoadSuccessListener = (placementId) {
    //   AdPopcornSSP.showInterstitial('118439798', 'V247cLQwngSgnN4');
    // };
    // AdPopcornSSP.interstitialAdLoadFailListener = (placementId, error) {
    //   print('Interstitial Ad Failed: $placementId, Error: $error');
    // };

    return RefreshIndicator(
      backgroundColor: AppColors.recipeColor,
      color: AppColors.primarySelectedColor,

      onRefresh: () async {
        ref.refresh(recommendChannelsProvider);
        ref.refresh(recommendVideosProvider);
        ref.refresh(recentVideosProvider);
        ref.refresh(seasonListProvider);
        ref.refresh(keywordListProvider);
      },
      child: UpdateChecker(
        child: Scaffold(
          appBar: AppbarWidget(),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Platform.isAndroid ? AdPopcornBanner() :IOSAdMobBanner(),
                AdPopcornBanner(),
                Container(
                  margin: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.primaryColor,
                  ),
                  child: RecommendRecipe(recommendVideoListAsyncValue: videos),
                ),

                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: RecentVideo(
                    recentVideoListAsyncValue: recentVideos,
                  ),
                ),

                // HomeScreen에서 채널 아이템 클릭 시
                RecommendChannel(
                  recommendChannelsListAsyncValue: channels,
                  onChannelItemClick: (channelData) {},
                ),
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
        ),
      ),
    );
  }
}