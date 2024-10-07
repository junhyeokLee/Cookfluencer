import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/ui/widget/common/CustomChannelImage.dart';
import 'package:flutter/material.dart';
import '../../../common/constant/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChannelItem extends StatelessWidget {
  final ChannelData channelData; // 채널 데이터
  final double size;
  final VoidCallback onChannelItemClick; // 채널 클릭 시 호출할 콜백 추가

  const ChannelItem({
    Key? key,
    required this.channelData,
    required this.size,
    required this.onChannelItemClick, // 콜백 전달
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChannelItemClick(); // 채널 클릭 시 콜백 호출
      },
      splashColor: Colors.transparent,    // 물결 효과를 투명으로 설정
      highlightColor: Colors.transparent, // 클릭 시 하이라이트 효과를 투명으로 설정
      child: Container(
        width: size, // 전달받은 사이즈 사용
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 채널 이미지 (CachedNetworkImage 사용)
            Hero(
              tag: 'channelHero_${channelData.id}', // 채널 ID를 태그로 사용
              child: Customchannelimage(
                imageUrl: channelData.thumbnailUrl,
                size: size,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(Assets.youtube, width: 20.w, height: 20.h), // youtube 아이콘
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        channelData.channelName,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 이름이 길면 생략
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  Image.asset(
                    Assets.group,
                    width: 16.w,
                    height: 16.h,
                  ),
                  SizedBox(width: 4),
                  Text(
                    channelData.subscriberCount.toSubscribeUnit(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.grey,
                          fontSize: 10.sp
                      )
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 4),
                    child: Center(
                      child: ClipOval(
                        child: Container(
                          width: 2,
                          height: 2,
                          color: AppColors.grey,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '동영상 ${channelData.videoCount}개', // 채널에 있는 동영상 개수
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.grey,
                        fontSize: 10.sp
                      )
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
