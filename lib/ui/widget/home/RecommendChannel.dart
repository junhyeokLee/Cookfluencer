import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/common.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
import 'package:cookfluencer/ui/widget/home/RecommendChannelVideo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecommendChannel extends HookConsumerWidget {
  const RecommendChannel({
    super.key,
    required this.recommendChannelsListAsyncValue,
  });

  final List<Map<String, dynamic>> recommendChannelsListAsyncValue; // 비디오 리스트 (썸네일, 제목, 설명 등 포함)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0); // 현재 슬라이더의 인덱스 저장

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 24, bottom: 12),
          child:
              Text('추천 인플루언서', style: Theme.of(context).textTheme.labelLarge),
        ),
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                // height: null, // Carousel 전체 높이
                // Carousel 전체 높이
                aspectRatio: 0.85,
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                initialPage: 0,
                viewportFraction: 0.85,
                // 각 페이지 비율
                padEnds: false,
                // 양쪽 끝 패딩 제거
                onPageChanged: (index, reason) {
                  currentIndex.value = index; // 페이지 변경 시 상태 업데이트
                },
              ),
              items:
                  recommendChannelsListAsyncValue.asMap().entries.map((entry) {
                var channel = entry.value; // 채널 데이터

                // 패딩 설정
                int subScribeCount =
                    int.tryParse(channel['subscriber_count'].toString()) ??
                        0; // 숫자로 변환
                int viewCount =
                    int.tryParse(channel['view_count'].toString()) ??
                        0; // 숫자로 변환
                return Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        child: Row(
                          children: [
                            Container(
                              width: ScreenUtil.width(context, 0.25),
                              // 화면 너비의 60%로 설정
                              height: ScreenUtil.width(context, 0.25),
                              // 1:1 비율로 높이 설정
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                // 라운드 처리
                                child: CachedNetworkImage(
                                  imageUrl: channel['thumbnail_url'],
                                  // 비디오 썸네일 표시
                                  fit: BoxFit.cover,
                                  // 또는 none
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.greyBackground),
                                  )),
                                  // 로딩 중 인디케이터
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error), // 에러 발생 시 아이콘 표시
                                ),
                              ),
                            ),
                            const SizedBox(width: 12), // 간격을 줄임
                            Expanded(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Image.asset(Assets.youtube,
                                          width: 18,
                                          height: 18,
                                          color: AppColors.black),
                                      // youtube 아이콘
                                      SizedBox(width: 5),
                                      // 간격
                                      Container(
                                        width: ScreenUtil.width(context, 0.35),
                                        child: Text(
                                          channel['channel_name'], // 채널이름
                                          maxLines: 1,
                                          // 한 줄로 제한
                                          overflow: TextOverflow.ellipsis,
                                          // 길어질 경우 생략
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 6), // 간격
                                  Row(
                                    children: [
                                      Image.asset(Assets.group,
                                          width: 14,
                                          height: 14,
                                          color: AppColors.grey), // group 아이콘
                                      SizedBox(width: 5), // 간격
                                      Text(
                                        subScribeCount.toSubscribeUnit(),
                                        // 비디오 설명
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                      SizedBox(width: 4), // 간격
                                      CircleAvatar(
                                        radius: 1,
                                        backgroundColor: AppColors.grey,
                                      ),
                                      SizedBox(width: 4), // 간격
                                      Text(
                                        '동영상 ${channel['video_count'] ?? 0}개',
                                        // 채널이름
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: AppColors.grey,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            Icon(Icons.arrow_forward_ios_rounded,
                                color: AppColors.black, size: 12), // 화살표 아이콘
                          ],
                        ),
                      ),
                      // 채널의 비디오 리스트 표시 (최대 3개)
                      SizedBox(height: 16),
                      RecommendChannelVideos(channelId: channel['id']),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        Container(
          padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: recommendChannelsListAsyncValue.map((video) {
              int index = recommendChannelsListAsyncValue.indexOf(video);
              return Container(
                width: 8.0,
                height: 8.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentIndex.value == index
                      ? Colors.black
                      : Colors.grey, // 현재 페이지와 동일한 인덱스에 색상 변경
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
