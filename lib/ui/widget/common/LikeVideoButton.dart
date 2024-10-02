import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/LikeVideoStatusNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';

class LikeVideoButton extends ConsumerWidget {
  final VideoData videoData;
  final double rightMargin;

  const LikeVideoButton({
    super.key,
    required this.videoData,
    required this.rightMargin,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 좋아요 상태를 가져옴
    final likeStatus = ref.watch(likeVideoStatusProvider);
    final isLiked = likeStatus[videoData.videoId]?.isLiked ?? false;

    // 좋아요 상태를 토글하는 함수
    Future<void> _toggleLike() async {
      // 좋아요 상태를 반전하여 업데이트된 데이터를 생성
      final updatedVideo = videoData.copyWith(isLiked: !isLiked);
      // 상태를 업데이트
      ref.read(likeVideoStatusProvider.notifier).toggleLike(updatedVideo);
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
  }
}
