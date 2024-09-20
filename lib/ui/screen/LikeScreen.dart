import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItem.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../provider/LikeStatusNotifier.dart'; // SharedPreferences 관련 메소드 가져옵니다.

class LikeScreen extends ConsumerWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Like'),
          bottom: TabBar(
            labelColor: AppColors.primarySelectedColor,
            unselectedLabelColor: AppColors.black,
            indicatorColor: AppColors.primarySelectedColor,
            dividerColor: Colors.transparent,
            indicatorPadding: EdgeInsets.only(left: 24, right: 24),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: [
              Tab(
                child: Text(
                  '인플루언서',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    // 기타 원하는 스타일 속성 추가 가능
                  ),
                ),
              ),
              Tab(
                child: Text(
                  '레시피',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    // 기타 원하는 스타일 속성 추가 가능
                  ),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 인플루언서 탭
            _buildInfluencerTab(),
            // 레시피 탭
            _buildRecipeTab(),
          ],
        ),
      ),
    );
  }

  // 인플루언서 탭을 위한 빌더
  Widget _buildInfluencerTab() {
    return Consumer(
      builder: (context, ref, child) {
        // 좋아요 상태를 가져오는 프로바이더
        final likedChannels = ref.watch(likeStatusProvider);
        // 데이터가 없거나 에러인 경우 처리
        if (likedChannels.isEmpty) {
          return const Center(child: EmptyMessage( message: '저장된 인플루언서가 없습니다.',));
        }

        // 좋아요된 채널 리스트
        final likedChannelsList = likedChannels.values
            .where((channel) => channel.isLiked)
            .toList();

        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          child: ListView.builder(
            itemCount: likedChannelsList.length,
            itemBuilder: (context, index) {
              final channel = likedChannelsList[index];
              final channelData = ChannelData(
                id: channel.id,
                channelName: channel.channelName,
                channelDescription: channel.channelDescription,
                channelUrl: channel.channelUrl,
                thumbnailUrl: channel.thumbnailUrl,
                subscriberCount: channel.subscriberCount,
                videoCount: channel.videoCount,
                isLiked: channel.isLiked,
                );
              debugPrint('채널 저장 데이터!: $channelData');
              return ChannelItemHorizontal(channelData: channelData);
            },
          ),
        );
      },
    );
  }

  // 레시피 탭을 위한 빌더
  Widget _buildRecipeTab() {
    return Center(child: Text('No recipes found.'));
  }
}
