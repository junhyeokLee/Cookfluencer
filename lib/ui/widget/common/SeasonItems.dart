import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/data/seasonData.dart';
import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/LikeStatusNotifier.dart';
import 'package:cookfluencer/sharedPreferences/sharedPreferences.dart';
import 'package:cookfluencer/ui/widget/common/LikeChannelButton.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';

class SeasonItems extends HookConsumerWidget {
  final SeasonData seasonData;

  const SeasonItems({
    Key? key,
    required this.seasonData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  seasonData.title,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  seasonData.sub_title,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ],
            ),
            ClipOval(
              child: Image.network(
                seasonData.image,
                width: ScreenUtil.width(context, 0.16),
                height: ScreenUtil.width(context, 0.16),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20), // 간격

        // videos 리스트의 데이터를 매핑하여 표시
        seasonData.videos.isEmpty
            ? const EmptyMessage(message: '이 채널에는 비디오가 없습니다.') // 비디오가 없을 때 메시지
            : ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: seasonData.videos.length,
          itemBuilder: (context, index) {
            final video = seasonData.videos[index];
            return VideoItem(
              video: video,
              size: ScreenUtil.width(context, 0.25), // 썸네일 사이즈
              titleWidth: ScreenUtil.width(context, 0.4), // 제목 너비
              channelWidth: ScreenUtil.width(context, 0.14), // 채널 이름 너비
            );
          },
        ),
      ],
    );
  }
}