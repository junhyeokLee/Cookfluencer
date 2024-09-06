import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/RecommendChannel.dart';
import 'package:cookfluencer/ui/widget/RecommendRecipe.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class HomeList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 채널과 비디오 리스트를 가져오기
    final recommendChannelsAsyncValue = ref.watch(recommendChannelsProvider);
    final recommendVideoListAsyncValue = ref.watch(recommendVideosProvider);

    return SingleChildScrollView(
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
            loading: () => Center(
              child: CircularProgressIndicator(color: AppColors.greyBackground),
            ),
            error: (error, stackTrace) => Center(
              child: Text('추천 레시피 로드 중 오류 발생: $error'),
            ),
          ),
          // 추천 채널 리스트
          recommendChannelsAsyncValue.when(
            data: (channelsSnapshots) {
              // QueryDocumentSnapshot에서 Map<String, dynamic>으로 변환
              List<Map<String, dynamic>> channels = channelsSnapshots
                  .map((doc) => doc.data() as Map<String, dynamic>)
                  .toList();
              return Recommendchannel(recommendChannelsListAsyncValue: channels);
            },
            loading: () => Center(
              child: CircularProgressIndicator(color: AppColors.greyBackground),
            ),
            error: (error, stackTrace) => Center(
              child: Text('추천 채널 로드 중 오류 발생: $error'),
            ),
          ),
        ],
      ),
    );
  }
}