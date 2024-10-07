import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/data/seasonData.dart';
import 'package:cookfluencer/ui/widget/common/PageIndicator.dart';
import 'package:cookfluencer/ui/widget/common/SeasonItems.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecommendSeasonRecipe extends HookConsumerWidget {
  const RecommendSeasonRecipe({
    super.key,
    required this.recommendSeasonListAsyncValue,
  });

  final List<Map<String, dynamic>> recommendSeasonListAsyncValue; // 채널 리스트 (썸네일, 제목, 설명 등 포함)

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = useState(0); // 현재 슬라이더의 인덱스 저장

    // 사용할 컬러 리스트
    List<Color> themeColors = [
      AppColors.themeColor1,
      AppColors.themeColor2,
      AppColors.themeColor3,
      AppColors.themeColor4,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
          child: Text(
              '시즌/테마별 레시피',
              style: Theme.of(context).textTheme.titleLarge
          ),
        ),
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                aspectRatio: 0.78, // Carousel 전체 높이 비율
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                initialPage: 0,
                viewportFraction: 0.88, // 각 페이지 비율
                padEnds: false, // 양쪽 끝 패딩 제거
                onPageChanged: (index, reason) {
                  currentIndex.value = index; // 페이지 변경 시 상태 업데이트
                },
              ),
              items: recommendSeasonListAsyncValue.asMap().entries.map((entry) {
                int index = entry.key;
                var season = entry.value; // 채널 데이터
                final seasonData = SeasonData.fromJson(season);

                // 각 카드의 인덱스에 따라 배경색 설정
                Color backgroundColor = themeColors[index % themeColors.length];

                return Container(
                  margin: EdgeInsets.only(top: 0, left: 16, right: 0, bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16), // 모서리를 둥글게 설정
                    color: backgroundColor, // 배경색 설정
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 24, top: 20,right: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SeasonItems(
                            seasonData: seasonData
                        ),
                        // 채널의 비디오 리스트 표시 (최대 3개)
                        SizedBox(height: 16),

                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
        PageIndicator(
          currentIndex: currentIndex.value, // 현재 페이지 인덱스
          itemCount: recommendSeasonListAsyncValue.length, // 전체 아이템 수
          activeColor: AppColors.primarySelectedColor, // 활성화된 인디케이터 색상
          inactiveColor: Colors.grey, // 비활성화된 인디케이터 색상
          dotSize: 8.0, // 인디케이터 크기
          spacing: 4.0, // 인디케이터 간 간격
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
