import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/LikeChannelStatusNotifier.dart';
import 'package:cookfluencer/provider/LikeVideoStatusNotifier.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/screen/VideoDetailScreen.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LikeScreen extends ConsumerWidget {
  const LikeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          // title: Text('Like'),
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
        final likedChannels = ref.watch(likeChannelStatusProvider);
        // 데이터가 없거나 에러인 경우 처리
        if (likedChannels.isEmpty) {
          return const Center(
            child: EmptyMessage(message: '저장된 인플루언서가 없습니다.'),
          );
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

              return ChannelItemHorizontal(
                channelData: channelData,
                onChannelItemClick: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) => ChannelDetailScreen(channelData: channelData),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        const begin = Offset(1.0, 0.0); // 시작 위치
                        const end = Offset.zero; // 끝 위치
                        const curve = Curves.easeInOut; // 애니메이션 곡선
                        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve)); // 트윈 설정
                        final offsetAnimation = animation.drive(tween); // 애니메이션 드라이버

                        return SlideTransition(
                          position: offsetAnimation, // 슬라이드 전환 애니메이션
                          child: child,
                        );
                      },
                      transitionDuration: const Duration(milliseconds: 300), // 애니메이션 지속 시간
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }

  // 레시피 탭을 위한 빌더
  Widget _buildRecipeTab() {
    return Consumer(
      builder: (context, ref, child) {
        final likedVideos = ref.watch(likeVideoStatusProvider);
        if (likedVideos.isEmpty) {
          return const Center(
            child: EmptyMessage(message: '저장된 레시피가 없습니다.'),
          );
        }
        final likedVideosList = likedVideos.values
            .where((video) => video.isLiked)
            .toList();

        return Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 16,left: 16,right: 16),
          child: ListView.builder(
            itemCount: likedVideosList.length,
            itemBuilder: (context, index) {
              final video = likedVideosList[index];
              final videoData = VideoData(
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

              return VideoItem(
                video: videoData,
                size: ScreenUtil.width(context, 0.2),
                titleWidth: ScreenUtil.width(context, 0.6),
                channelWidth: ScreenUtil.width(context, 0.25),
                onVideoItemClick: () {},
                showLikeButton: true,
              );
            },
          ),
        );
      },
    );
  }
}