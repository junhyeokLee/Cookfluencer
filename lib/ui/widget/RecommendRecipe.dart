import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/util/ScrrenUtil.dart';
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
          padding: const EdgeInsets.only(left: 24, top: 24, bottom: 12),
          child: Text('쿡플루언서 추천 레시피', style: Theme.of(context).textTheme.labelLarge),
        ),
        Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                autoPlay: false,
                height: MediaQuery.of(context).size.width * 0.82, // Carousel 전체 높이
                enableInfiniteScroll: true,
                enlargeCenterPage: false,
                initialPage: 0,
                viewportFraction: 0.6, // 각 페이지 비율
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
                        width: ScreenUtil.width(context, 0.6), // 화면 너비의 60%로 설정
                        height: ScreenUtil.width(context, 0.6), // 1:1 비율로 높이 설정
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0), // 라운드 처리
                          child: CachedNetworkImage(
                            imageUrl: video['thumbnail_url'], // 비디오 썸네일 표시
                            fit: BoxFit.cover, // 또는 none
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.greyBackground),
                            )), // 로딩 중 인디케이터
                            errorWidget: (context, url, error) => const Icon(Icons.error), // 에러 발생 시 아이콘 표시
                          ),
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
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                           Image.asset(Assets.view,width: 14,height: 14,color: AppColors.grey), // 별 아이콘
                          SizedBox(width: 4), // 간격
                          Text(
                            viewCount.toViewCountUnit(), // 조회수를 한국어 형식으로 변환
                            style: TextStyle(
                              color: AppColors.grey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 16), // 간격
                          Image.asset(Assets.youtube,width: 14,height: 14,color: AppColors.grey), // 별 아이콘
                          SizedBox(width: 4), // 간격
                          Expanded( // 공간을 차지하게 하여 텍스트가 넘어가지 않도록 설정
                            child: Text(
                              video['channel_name'].toString(), // 채널 이름
                              maxLines: 1, // 한 줄로 제한
                              overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                              style: TextStyle(
                                color: AppColors.grey,
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
            SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: recommendVideoListAsyncValue.map((video) {
                  int index = recommendVideoListAsyncValue.indexOf(video);
                  return Container(
                    width: 8.0,
                    height: 8.0,
                    margin: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 4.0),
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
        ),
      ],
    );
  }

  // 인덱스에 따라 패딩을 반환하는 메서드
  EdgeInsets _getPaddingForIndex(int index, int totalCount) {
    if (index == 0) {
      return const EdgeInsets.only(left: 24); // 첫 번째 항목
    } else if (index == totalCount - 1) {
      return const EdgeInsets.only(left: 12, right: 0); // 마지막 항목
    } else {
      return const EdgeInsets.only(left: 12); // 나머지 항목
    }
  }
}