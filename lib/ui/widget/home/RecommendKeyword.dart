import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/common.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/ui/widget/common/BarIndicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cookfluencer/ui/widget/common/KeywordChip.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecommendKeyword extends HookConsumerWidget {
  const RecommendKeyword({
    super.key,
    required this.keywordListAsyncValue,
  });

  final List<Map<String, dynamic>> keywordListAsyncValue; // 키워드 리스트

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final keywordListAsyncValue = ref.watch(keywordListProvider);
    final selectedKeyword = useState<String?>(null); // 선택된 키워드를 추적하기 위한 상태
    final currentIndex = useState(0); // Carousel의 현재 페이지 인덱스

    return SingleChildScrollView(
      child: keywordListAsyncValue.when(
        data: (keywords) {
          if (keywords.isEmpty) {
            return const Text('키워드가 없습니다.');
          }
          // 첫 번째 키워드를 기본 선택값으로 설정
          if (selectedKeyword.value == null) {
            selectedKeyword.value = (keywords.first.data()
            as Map<String, dynamic>)['name']; // 첫 번째 키워드 설정
          }
          final keywrodVideoListAsyncValue =
          ref.watch(searchKeywordVideoProvider(selectedKeyword.value!));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 24, bottom: 12),
                child: Text(
                  '이 키워드를 주목하세요',
                    style: context.textTheme.titleLarge,
                ),
              ),
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      pageSnapping: false,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      enlargeCenterPage: false,
                      initialPage: 0,
                      viewportFraction: 0.64, // 각 슬라이드의 비율
                      padEnds: false, // 양쪽 끝 패딩 제거
                      onPageChanged: (index, reason) {
                        currentIndex.value = index; // 현재 페이지 인덱스 업데이트
                        final keyword = keywords[index].data() as Map<String, dynamic>;
                        if (selectedKeyword.value != keyword['name']) {
                          selectedKeyword.value = keyword['name'];
                        }
                      },
                    ),
                    items: keywords.map((keywordData) {
                      final keyword = keywordData.data() as Map<String, dynamic>;
                      int index = keywords.indexOf(keywordData); // 현재 인덱스
                      final isSelected = selectedKeyword.value == keyword['name']; // 선택 여부 확인

                      EdgeInsets padding = _getPaddingForIndex(index, keyword.length);

                      // KeywordChip을 사용하여 키워드 렌더링
                      return Padding(
                        padding: padding,
                        child: KeywordChip(
                          keyword: keyword['name'] ?? '', // 키워드 이름
                          image: keyword['image'] ?? '', // 이미지
                          isSelected: isSelected, // 선택 상태 전달
                          onTap: () {
                            // 키워드 선택 로직
                            if (selectedKeyword.value != keyword['name']) {
                              selectedKeyword.value = keyword['name']; // 새로운 키워드 선택
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  BarIndicator(
                    currentIndex: currentIndex.value == keywords.length - 1 ? currentIndex.value + 1 : currentIndex.value, // 마지막 인덱스일 경우 +1
                    itemCount: keywords.length-1, // 마지막 인덱스일 경우 아이템 수 +1
                    activeColor: AppColors.primarySelectedColor, // 활성화된 인디케이터 색상
                    inactiveColor: Colors.grey, // 비활성화된 인디케이터 색상
                    barWidth: 0.8.sw, // 인디케이터 크기
                    barHeight: 4.0, // 인디케이터 간 간격
                  ),
                  SizedBox(height: 20,)
                ],
              ),
              if (selectedKeyword.value != null) // 선택된 키워드가 있을 때만 아래 리스트 표시
                Center()
            ],
          );
        },
        loading: () => CircularLoading(),
        error: (error, stackTrace) => ErrorMessage(message: '${error}'),
      ),
    );
  }
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
