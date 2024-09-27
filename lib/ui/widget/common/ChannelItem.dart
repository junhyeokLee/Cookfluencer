import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/routing/appRoute.dart';
import 'package:cookfluencer/ui/widget/common/CustomChannelImage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/constant/app_colors.dart';

class ChannelItem extends StatelessWidget {
  final ChannelData channelData; // 채널 데이터
  final double size;

  const ChannelItem({
    Key? key,
    required this.channelData,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // 채널 클릭 시 채널 상세 화면으로 이동
        // 채널 아이템 클릭 시 ChannelDetailScreen으로 이동
        context.pushNamed(
          AppRoute.channelDetail.name, // 이동할 라우트 이름
          extra: channelData, // 객체 전달
        );
      },
      child: Container(
        width: size, // 전달받은 사이즈 사용
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 채널 이미지 (CachedNetworkImage 사용)
            Customchannelimage(
              imageUrl: channelData.thumbnailUrl,
              size: size,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(width: 3.7),
                    Image.asset(Assets.youtube,width: 20,height: 20), // 별 아이콘AppColors.grey
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        channelData.channelName,
                        style: Theme.of(context).textTheme.labelMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis, // 이름이 길면 생략
                      ),
                    ),
                  ],
                ),
              ),
            ), // youtube 아이콘
            SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Row(
                children: [
                  Image.asset(
                    Assets.group,
                    width: 16,
                    height: 16,
                    color: AppColors.grey,
                  ),
                  SizedBox(width: 4),
                  Text(
                    channelData.subscriberCount.toSubscribeUnit(),
                    style: TextStyle(
                      color: AppColors.grey,
                      fontSize: 12,
                    ),
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
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                      ),
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