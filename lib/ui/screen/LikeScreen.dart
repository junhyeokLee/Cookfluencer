import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/LikeChannelStatusNotifier.dart';
import 'package:cookfluencer/provider/LikeVideoStatusNotifier.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LikeScreen extends ConsumerWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppbarWidget(), // AppBar 설정 확인
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(), // TabBar 빌더
            Expanded(
              // TabBarView를 감싸는 Expanded 추가
              child: TabBarView(
                children: [
                  _buildInfluencerTab(ref),
                  _buildRecipeTab(ref),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TabBar 빌더
  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      labelColor: AppColors.primarySelectedColor,
      unselectedLabelColor: AppColors.black,
      indicatorColor: AppColors.primarySelectedColor,
      dividerColor: Colors.transparent,
      indicatorPadding: const EdgeInsets.only(left: 24, right: 24),
      indicatorSize: TabBarIndicatorSize.tab,
      tabs: const [
        Tab(
          child: Text(
            '인플루언서',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Tab(
          child: Text(
            '레시피',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // 인플루언서 탭 빌더
  Widget _buildInfluencerTab(WidgetRef ref) {
    final likedChannels = ref.watch(likeChannelStatusProvider);
    debugPrint('저장된 인플루언서: $likedChannels');

    if (likedChannels.isEmpty) {
      return const Center(
        child: EmptyMessage(message: '저장된 인플루언서가 없습니다.'),
      );
    }

    final likedChannelsList =
        likedChannels.values.where((channel) => channel.isLiked).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.builder(
        itemCount: likedChannelsList.length,
        itemBuilder: (context, index) {
          final channel = likedChannelsList[index];
          final channelData = _createChannelData(channel);

          return ChannelItemHorizontal(
            channelData: channelData,
            onChannelItemClick: () {
              _navigateToChannelDetail(context, channelData);
            },
          );
        },
      ),
    );
  }

  // 레시피 탭 빌더
  Widget _buildRecipeTab(WidgetRef ref) {
    final likedVideos = ref.watch(likeVideoStatusProvider);

    debugPrint('저장된 비디오: $likedVideos');

    if (likedVideos.isEmpty) {
      return const Center(
        child: EmptyMessage(message: '저장된 레시피가 없습니다.'),
      );
    }

    final likedVideosList =
        likedVideos.values.where((video) => video.isLiked).toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: ListView.builder(
        itemCount: likedVideosList.length,
        itemBuilder: (context, index) {
          final video = likedVideosList[index];
          final videoData = _createVideoData(video);

          return VideoItem(
            video: videoData,
            size: 0.2.sw,
            titleWidth: 0.6.sw,
            channelWidth: 0.25.sw,
            onVideoItemClick: () {
              // 비디오 클릭 시 동작
            },
            showLikeButton: true,
          );
        },
      ),
    );
  }

  // 채널 데이터 생성 메서드
  ChannelData _createChannelData(channel) {
    return ChannelData(
      id: channel.id,
      channelName: channel.channelName,
      channelDescription: channel.channelDescription,
      channelUrl: channel.channelUrl,
      thumbnailUrl: channel.thumbnailUrl,
      subscriberCount: channel.subscriberCount,
      videoCount: channel.videoCount,
      isLiked: channel.isLiked,
    );
  }

  // 비디오 데이터 생성 메서드
  VideoData _createVideoData(video) {
    return VideoData(
      id: video.id,
      channelId: video.channelId,
      channelName: video.channelName,
      description: video.description,
      thumbnailUrl: video.thumbnailUrl,
      title: video.title,
      uploadDate: video.uploadDate,
      videoId: video.videoId,
      videoUrl: video.videoUrl,
      viewCount: video.viewCount,
      section: video.section,
      isLiked: video.isLiked,
    );
  }

  // 채널 상세 화면으로 이동하는 메서드
  void _navigateToChannelDetail(BuildContext context, ChannelData channelData) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            ChannelDetailScreen(channelData: channelData),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          final tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          final offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}
