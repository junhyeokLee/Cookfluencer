import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/data/seasonData.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cookfluencer/ui/widget/common/VideoItem.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  seasonData.sub_title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            ClipOval(
              child: Image.network(
                seasonData.image,
                width: 0.16.sw,
                height: 0.16.sw,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
              ),
            ),
          ],
        ),

        const SizedBox(height: 32), // 간격

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
              size: 0.25.sw, // 썸네일 사이즈
              titleWidth: 0.45.sw, // 제목 너비
              channelWidth: 0.12.sw,
              onVideoItemClick: () {

              }, // 채널 이름 너비
            );
          },
        ),
      ],
    );
  }
}