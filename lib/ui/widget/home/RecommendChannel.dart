import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/common.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/common/CustomChannelImage.dart';
import 'package:cookfluencer/ui/widget/common/PageIndicator.dart';
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
              items: recommendChannelsListAsyncValue.asMap().entries.map((entry) {
                var channel = entry.value; // 채널 데이터

                // 패딩 설정
                int subScribeCount = int.tryParse(channel['subscriber_count'].toString()) ?? 0; // 숫자로 변환
                int viewCount = int.tryParse(channel['view_count'].toString()) ?? 0; // 숫자로 변환
                return Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      ChannelItemHorizontal(
                        channelName: channel['channel_name'],
                        imageUrl: channel['thumbnail_url'],
                        subscriberCount: subScribeCount,
                        videoCount: channel['video_count'] ?? 0,
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

        PageIndicator(
          currentIndex: currentIndex.value, // 현재 페이지 인덱스
          itemCount: recommendChannelsListAsyncValue.length, // 전체 아이템 수
          activeColor: Colors.black, // 활성화된 인디케이터 색상
          inactiveColor: Colors.grey, // 비활성화된 인디케이터 색상
          dotSize: 8.0, // 인디케이터 크기
          spacing: 4.0, // 인디케이터 간 간격
        ),
      ],
    );
  }
}
