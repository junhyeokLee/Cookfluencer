import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
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


class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recommendChannelsAsyncValue = ref.watch(recommendChannelsProvider);
    final recommendVideoListAsyncValue = ref.watch(recommendVideosProvider);
    final recommendSeasonAsyncValue = ref.watch(seasonListProvider);
    final keywordListAsyncValue = ref.watch(keywordListProvider);

    final isLoading = recommendChannelsAsyncValue.isLoading ||
        recommendVideoListAsyncValue.isLoading ||
        keywordListAsyncValue.isLoading;

    final hasError = recommendChannelsAsyncValue.hasError ||
        recommendVideoListAsyncValue.hasError ||
        keywordListAsyncValue.hasError;

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

    if (isLoading) {
      return Scaffold(
        appBar: AppbarWidget(),
        body: Center(
          child: CircularLoading(),
        ),
      );
    }

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
            Container(
              margin: EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.primaryColor,
              ),
              child: RecommendRecipe(recommendVideoListAsyncValue: videos),
            ),
            // HomeScreen에서 채널 아이템 클릭 시
            RecommendChannel(
              recommendChannelsListAsyncValue: channels,
              onChannelItemClick: (channelData) {
                // print("Channel clicked: ${channelData}"); // 로그 확인
                // context.goNamed(
                //   AppRoute.channelDetail.name, // 경로를 '/home/channel/{id}'로 수정하여 중복 방지
                //   extra: channelData, // 채널 데이터 전체를 extra로 전달
                // );
                // context.go('/home/channelDetail', extra: channelData);
              },
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
    );
  }
}