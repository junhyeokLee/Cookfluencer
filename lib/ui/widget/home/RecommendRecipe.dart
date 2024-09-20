import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/ui/widget/common/CustomVideoImage.dart';
import 'package:cookfluencer/ui/widget/common/PageIndicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cookfluencer/common/dart/extension/num_extension.dart';


class RecommendRecipe extends HookConsumerWidget {
  const RecommendRecipe({
    super.key,
    required this.recommendVideoListAsyncValue,
  });

  final List<Map<String, dynamic>> recommendVideoListAsyncValue; // 비디오 리스트 (썸네일, 제목, 설명 등 포함)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0); // 현재 슬라이더의 인덱스 저장

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 24, top: 20, bottom: 16),
          child: Text('오늘의 추천 레시피', style: Theme.of(context).textTheme.labelLarge),
        ),
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                height: MediaQuery.of(context).size.width * 0.9, // Carousel 전체 높이
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                initialPage: 0,
                viewportFraction: 0.75, // 각 페이지 비율
                padEnds: false, // 양쪽 끝 패딩 제거
                onPageChanged: (index, reason) {
                  currentIndex.value = index; // 페이지 변경 시 상태 업데이트
                },
              ),
              items: recommendVideoListAsyncValue.asMap().entries.map((entry) {
                int index = entry.key; // 현재 인덱스
                var video = entry.value; // 비디오 데이터

                // 패딩 설정
                EdgeInsets padding = _getPaddingForIndex(index, recommendVideoListAsyncValue.length);
                int viewCount = int.tryParse(video['view_count'].toString()) ?? 0; // 숫자로 변환
                return Padding(
                  padding: padding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: CustomVideoImage(
                          imageUrl: video['thumbnail_url'],
                          size: ScreenUtil.width(context, 0.65),
                          fit: BoxFit.none,
                          icon: Image.asset(Assets.recipe_ai, width: 28, height: 28), // 플레이 아이콘
                        ),
                      ),
                      const SizedBox(height: 16), // 간격을 줄임
                      Text(
                        video['title'], // 비디오 제목
                        maxLines: 1, // 한 줄로 제한
                        overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        video['description'], // 비디오 설명
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                           Image.asset(Assets.view,width: 14,height: 14,color: AppColors.greyDeep), // 별 아이콘
                          SizedBox(width: 4), // 간격
                          Text(
                            viewCount.toViewCountUnit(), // 조회수를 한국어 형식으로 변환
                            style: TextStyle(
                              color: AppColors.greyDeep,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 16), // 간격
                          Image.asset(Assets.youtube,width: 20,height: 20), // 별 아이콘AppColors.grey
                          SizedBox(width: 4), // 간격
                          Expanded( // 공간을 차지하게 하여 텍스트가 넘어가지 않도록 설정
                            child: Text(
                              video['channel_name'].toString(), // 채널 이름
                              maxLines: 1, // 한 줄로 제한
                              overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                              style: TextStyle(
                                color: AppColors.greyDeep,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList(),
            ),
            PageIndicator(
              currentIndex: currentIndex.value, // 현재 페이지 인덱스
              itemCount: recommendVideoListAsyncValue.length, // 전체 아이템 수
              activeColor: AppColors.primarySelectedColor, // 활성화된 인디케이터 색상
              inactiveColor: Colors.grey, // 비활성화된 인디케이터 색상
              dotSize: 8.0, // 인디케이터 크기
              spacing: 4.0, // 인디케이터 간 간격
            ),
            SizedBox(height: 20), // 간격 추가
          ],
        ),
      ],
    );
  }

  // 인덱스에 따라 패딩을 반환하는 메서드
  EdgeInsets _getPaddingForIndex(int index, int totalCount) {
    if (index == 0) {
      return const EdgeInsets.only(left: 24); // 첫 번째 항목
    } else if (index == totalCount - 1) {
      return const EdgeInsets.only(left: 16, right: 0); // 마지막 항목
    } else {
      return const EdgeInsets.only(left: 16); // 나머지 항목
    }
  }
}