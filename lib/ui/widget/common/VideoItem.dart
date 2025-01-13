import 'package:cookfluencer/data/videoData.dart';
import 'package:cookfluencer/ui/screen/VideoDetailScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';
import 'package:cookfluencer/ui/widget/common/CustomVideoImage.dart';
import 'package:cookfluencer/ui/widget/common/LikeVideoButton.dart'; // LikeVideoButton 추가
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../common/util/DateUtil.dart';
import 'CustomPageRouter.dart';

class VideoItem extends StatelessWidget {
  final VideoData video; // 비디오 데이터
  final double size; // 썸네일 사이즈
  final double titleWidth; // 비디오 제목 너비
  final double channelWidth; // 채널 이름 너비
  final VoidCallback onVideoItemClick;
  final bool showLikeButton; // 비디오 클릭 시 호출할 콜백 추가
  final bool showChannelName; // 채널 이름 표시 여부
  final bool paddiongNone;

  const VideoItem({
    Key? key,
    required this.video,
    required this.size, // 썸네일 사이즈 추가
    required this.titleWidth, // 제목 너비 추가
    required this.channelWidth, // 채널 이름 너비 추가
    required this.onVideoItemClick, // 콜백 전달
    this.showLikeButton = false,
    this.showChannelName = true, // 채널 이름 표시 여부 기본값 추가
    this.paddiongNone = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 에러 상태 확인 (예: 썸네일 URL이 없거나 비디오 제목이 비어있으면 에러로 판단)
    bool hasError = video.thumbnailUrl.isEmpty || video.title.isEmpty;

    return InkWell(
      // 에러가 있으면 클릭 이벤트를 null로 설정해 클릭 불가 상태로 만듦
      onTap: hasError
          ? null // 에러가 있을 경우 클릭 불가
          : () {
        // 정상적인 비디오 클릭 처리
        Navigator.of(context).push(
          CupertinoPageRoute(
            builder: (context) => VideoDetailScreen(videoData: video),
          ),
        );
      },
      child: Container(
        margin: paddiongNone ? EdgeInsets.zero : EdgeInsets.only(bottom: 16),
        padding: paddiongNone ? EdgeInsets.symmetric(horizontal: 0, vertical: 0) : EdgeInsets.symmetric(horizontal: 0, vertical: 4),
        decoration: BoxDecoration(
          color: hasError ? Colors.red.withOpacity(0.1) : Colors.transparent, // 에러 시 배경색 처리
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: size, // 전달받은 사이즈 사용
              height: size, // 1:1 비율 유지
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8), // 라운드 처리
                child: Hero(
                  // tag: 'video_${video.id}',
                  tag: '',
                  child: CustomVideoImage(
                    imageUrl: video.thumbnailUrl, // 썸네일 이미지
                    size: size,
                    fit: BoxFit.cover,
                    iconBottomPadding: 4.0,
                    iconRightPadding: 4.0,
                    icon: video.recipe != null &&
                        video.recipe!.video_id.isNotEmpty
                        ? Image.asset(Assets.recipe_ai,
                        width: 20.w, height: 20.h) // 활성화된 경우 아이콘
                        : Image.asset(Assets.recipe_ai,
                        width: 0, height: 0), // 비활성화된 경우 빈 아이콘 (0 크기)
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12), // 간격
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // 왼쪽 정렬
                children: [
                  showChannelName? Row(
                    children: [
                      Image.asset(Assets.youtube,width: 20.w),
                      // 별 아이콘AppColors.grey
                      SizedBox(width: 4),
                      Text(
                        video.channelName.length > 14
                            ? '${video.channelName.substring(0, 14)}...'
                            : video.channelName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                          color: AppColors.grey,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ): Container(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // 타이틀과 버튼 사이에 공간 배분
                    children: [
                      Container(
                        width: titleWidth, // 전달받은 제목 너비 사용
                        child: Text(
                          video.title, // 비디오 제목
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                      showLikeButton
                          ? LikeVideoButton(
                        videoData: video,
                        rightMargin: 0,
                      )
                          : Container(),
                    ],
                  ),
                  SizedBox(height: 6), // 간격
                  Row(
                    children: [
                      Text(
                        formatMonthDayDate(video.uploadDate), // 조회수를 한국어 형식으로 변환
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.copyWith(
                            color: AppColors.grey,
                            fontSize: 11.sp
                        ),
                      ),

                      Container(
                          padding: EdgeInsets.only(left: 6,right: 6),
                          child: Text(
                            '·',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.grey,
                            ),
                          )
                      ),

                      Text(video.viewCount.toViewCountUnit(),
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                            color: AppColors.grey,
                            fontSize: 11.sp,
                          )),

                      // Container(
                      //   width: channelWidth, // 전달받은 채널 이름 너비 사용
                      //   child: Text(
                      //     video.channelName, // 채널 이름
                      //     maxLines: 1,
                      //     overflow: TextOverflow.ellipsis,
                      //     style: Theme.of(context)
                      //         .textTheme
                      //         .labelSmall
                      //         ?.copyWith(
                      //       color: AppColors.grey,
                      //       fontSize: 10.sp,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}