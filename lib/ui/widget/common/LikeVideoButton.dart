import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/LikeVideoStatusNotifier.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
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

    return likeStatus.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, stack) => Text('Error: $e'),
      data: (data) {
        // 비디오 ID로 좋아요 상태 확인
        final isLiked = data[videoData.videoId]?.isLiked ?? false;

        // 좋아요 상태를 토글하는 함수
        Future<void> _toggleLike() async {
          try {
            // 좋아요 상태 반전
            final updatedVideo = videoData.copyWith(isLiked: !isLiked);

            // 상태를 바로 반영 (기기에 저장하기 전)
            ref.read(likeVideoStatusProvider.notifier).toggleLike(updatedVideo);

            // 비동기적으로 데이터 저장 또는 삭제
            if (updatedVideo.isLiked) {
              await saveVideoData(updatedVideo); // 기기에 비디오 데이터 저장

            } else {
              await removeVideoData(updatedVideo.id); // 기기에서 비디오 데이터 삭제

            }
          } catch (e) {
            debugPrint('좋아요 상태 변경 중 오류 발생: $e');
          }
        }

        return GestureDetector(
          onTap: _toggleLike,
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