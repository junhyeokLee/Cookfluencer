import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/LikeChannelStatusNotifier.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';

class LikeChannelButton extends ConsumerWidget {
  final ChannelData channelData;
  final double rightMargin;

  const LikeChannelButton({
    super.key,
    required this.channelData,
    required this.rightMargin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 좋아요 상태를 가져옴
    final likeStatus = ref.watch(likeChannelStatusProvider); // 현재 좋아요 상태를 가져옴

    return likeStatus.when(
      loading: () => const CircularProgressIndicator(), // 로딩 상태일 때 보여줄 위젯
      error: (e, stack) => Text('Error: $e'), // 에러 발생 시 보여줄 위젯
      data: (data) {
        final isLiked = data[channelData.id]?.isLiked ?? false; // 좋아요 여부 확인

        // 좋아요 상태를 토글하는 함수
        Future<void> _toggleLike() async {
          final updatedChannel = channelData.copyWith(isLiked: !isLiked); // 비디오 복사하여 상태 반전
          ref.read(likeChannelStatusProvider.notifier).toggleLike(updatedChannel); // 상태 업데이트

          // 비동기적으로 데이터 저장 또는 삭제
          if (updatedChannel.isLiked) {
            await saveChannelData(updatedChannel); // 좋아요 추가
          } else {
            await removeChannelData(updatedChannel.id); // 좋아요 제거
          }
        }

        return GestureDetector(
          onTap: _toggleLike, // 좋아요 상태를 변경
          child: Container(
            width: 32,
            height: 32,
            margin: EdgeInsets.only(right: rightMargin),
            child: ClipOval(
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    Assets.like,
                    width: 16,
                    height: 16,
                    color: isLiked
                        ? AppColors.likeAble // 좋아요 상태일 때 색상
                        : AppColors.likeEnable, // 좋아요 상태가 아닐 때 색상
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
