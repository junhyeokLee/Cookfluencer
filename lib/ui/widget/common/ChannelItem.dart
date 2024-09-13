import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
import 'package:cookfluencer/ui/widget/common/CustomChannelImage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../common/constant/app_colors.dart';

class ChannelItem extends StatelessWidget {
  final String channelName; // 채널 이름
  final String channelImage; // 채널 이미지 URL
  final int subscriberCount; // 구독자 수
  final int videoCount; // 동영상 개수
  final double size; // 채널 카드의 사이즈

  const ChannelItem({
    Key? key,
    required this.channelName,
    required this.channelImage,
    required this.subscriberCount,
    required this.videoCount,
    required this.size, // 사이즈 매개변수 추가
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, // 전달받은 사이즈 사용
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 채널 이미지 (CachedNetworkImage 사용)
          Customchannelimage(
            imageUrl: channelImage,
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
                  Image.asset(
                    Assets.youtube,
                    width: 16,
                    height: 16,
                    color: Colors.red,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      channelName,
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
                  subscriberCount.toSubscribeUnit(),
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
                    '동영상 $videoCount개', // 채널에 있는 동영상 개수
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
    );
  }
}