import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/LikeChannelStatusNotifier.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    final likeStatus = ref.watch(likeChannelStatusProvider);

    return likeStatus.when(
      loading: () => const CircularProgressIndicator(),
      error: (e, stack) => Text('Error: $e'),
      data: (data) {
        final isLiked = data[channelData.id]?.isLiked ?? false;

        Future<void> _toggleLike() async {
          final user = FirebaseAuth.instance.currentUser;

          if (user == null) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('로그인이 필요합니다', style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                )),
                content: const Text('좋아요 기능을 사용하려면 먼저 로그인해주세요.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('확인'),
                  ),
                ],
              ),
            );
            return;
          }
          ref.read(likeChannelStatusProvider.notifier).toggleLike(channelData);
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
                        ? AppColors.likeAble
                        : AppColors.likeEnable,
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
