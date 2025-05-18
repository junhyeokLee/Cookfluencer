import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/LikeChannelStatusNotifier.dart';
import 'package:cookfluencer/provider/LikeVideoStatusNotifier.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/widget/common/AppbarWidget.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../common/constant/assets.dart';
import '../../provider/AuthNotifier.dart';
import '../widget/AdNativeBottom.dart';

class LikeScreen extends ConsumerWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider); // 로그인 상태 구독
    final user = authState.user;

    return Scaffold(
      appBar: AppbarWidget(),
      body: authState.isLoading
          ? const Center(child: CircularProgressIndicator()) // 로딩 처리
          : user == null
          ? _buildGuestPrompt(ref)
          : DefaultTabController(
        length: 2,
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
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
  Column _buildTabBar() {
    return Column(
      children: [
        TabBar(
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
        ),
        // setNativeBottomView(),
        AdNativeBottom(),
      ],
    );
  }

  Widget _buildGuestPrompt(WidgetRef ref) {
    final isLoggingIn = ref.watch(authProvider).isLoading;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock_outline, size: 48, color: AppColors.grey),
          const SizedBox(height: 12),
          const Text(
            '로그인이 필요한 기능입니다',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: isLoggingIn
                ? null
                : () => ref.read(authProvider.notifier).loginWithKakao(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.kakaoYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!isLoggingIn)
                  Image.asset(Assets.kakaoLogo, width: 24, height: 24),
                const SizedBox(width: 8),
                isLoggingIn
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: AppColors.recipeColor,
                    strokeWidth: 2,
                  ),
                )
                    : const Text(
                  '카카오톡으로 로그인',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  // 인플루언서 탭 빌더
  Widget _buildInfluencerTab(WidgetRef ref) {
    // final likedChannels = ref.watch(likeChannelStatusProvider);
    final likedChannels = ref.watch(likeChannelStatusProvider);

    // AsyncValue 처리
    return likedChannels.when(
      data: (channels) {
        final likedChannelsList = channels.values.where((channel) => channel.isLiked).toList();

        if (likedChannelsList.isEmpty) {
          return const Center(
              child: EmptyMessage(message: '저장된 인플루언서가 없습니다.'));
        }

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
      },
      loading: () => const Center(child: CircularProgressIndicator()), // 로딩 중
      error: (error, stack) => Center(child: Text('에러 발생: $error')), // 에러 처리
    );
  }

  // 레시피 탭 빌더
  Widget _buildRecipeTab(WidgetRef ref) {
    // likeVideoStatusProvider의 타입을 AsyncValue<Map<String, LikeVideoStatus>>로 변경합니다.
    final likedVideos = ref.watch(likeVideoStatusProvider);

    // AsyncValue 처리
    return likedVideos.when(
      data: (videos) {
        final likedVideosList = videos.values.where((video) => video.isLiked).toList();

        if (likedVideosList.isEmpty) {
          return const Center(child: EmptyMessage(message: '저장된 레시피가 없습니다.'));
        }

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
                titleWidth: 0.59.sw,
                channelWidth: 0.25.sw,
                onVideoItemClick: () {
                  // 비디오 클릭 시 동작
                },
                showLikeButton: true,
              );
            },
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()), // 로딩 중
      error: (error, stack) => Center(child: Text('에러 발생: $error')), // 에러 처리
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
      recipe: video.recipe,
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