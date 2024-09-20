import 'package:carousel_slider/carousel_slider.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/ui/widget/common/BarIndicator.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:cookfluencer/ui/widget/common/KeywordChip.dart';
import 'package:cookfluencer/common/util/ScreenUtil.dart';
import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';

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
                child: Text('이 키워드를 주목하세요',
                    style: Theme.of(context).textTheme.labelLarge),
              ),
              Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      autoPlay: false,
                      enableInfiniteScroll: true,
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
                    currentIndex: currentIndex.value, // 현재 페이지 인덱스
                    itemCount: keywords.length, // 전체 아이템 수를 keywords의 길이로 설정
                    activeColor: AppColors.primarySelectedColor, // 활성화된 인디케이터 색상
                    inactiveColor: Colors.grey, // 비활성화된 인디케이터 색상
                    barWidth: ScreenUtil.width(context, 0.8), // 인디케이터 크기
                    barHeight: 4.0, // 인디케이터 간 간격
                  ),
                  SizedBox(height: 20,)
                ],
              ),
              if (selectedKeyword.value != null) // 선택된 키워드가 있을 때만 아래 리스트 표시
                // Padding(
                //   padding:
                //   const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       keywrodVideoListAsyncValue.when(
                //         data: (videos) {
                //           if (videos.isEmpty) {
                //             return Padding(
                //               padding:
                //               const EdgeInsets.only(top: 48, bottom: 56),
                //               child: Center(
                //                   child: const Text('이 키워드에는 비디오가 없습니다.')),
                //             );
                //           }
                //
                //           // 비디오 리스트가 있을 경우 최대 3개의 비디오를 세로로 표시
                //           return ListView.builder(
                //             shrinkWrap: true,
                //             physics: const NeverScrollableScrollPhysics(),
                //             itemCount: videos.length,
                //             itemBuilder: (context, index) {
                //               final video =
                //               videos[index].data() as Map<String, dynamic>;
                //               // ChannelModel에 데이터를 맵핑
                //               final videoData = VideoData(
                //                 id: video['id'] ?? 'Unknown',
                //                 channelId: video['channel_id'] ?? 'Unknown',
                //                 channelName: video['channel_name'] ?? 'Unknown',
                //                 description: video['description'] ?? '',
                //                 thumbnailUrl: video['thumbnail_url'] ?? '',
                //                 title: video['title'] ?? 'Unknown',
                //                 uploadDate: video['upload_date'] ?? '',
                //                 videoId: video['video_id'] ?? '',
                //                 videoUrl: video['video_url'] ?? '',
                //                 viewCount: int.tryParse(
                //                     video['view_count'].toString()) ??
                //                     0,
                //                 section: video['section'] ?? '',
                //               );
                //               return VideoItem(
                //                 video: videoData,
                //                 // 비디오 데이터
                //                 size: ScreenUtil.width(context, 0.25),
                //                 // 썸네일 사이즈
                //                 titleWidth: ScreenUtil.width(context, 0.6),
                //                 // 제목 너비
                //                 channelWidth:
                //                 ScreenUtil.width(context, 0.3), // 채널 이름 너비
                //               );
                //             },
                //           );
                //         },
                //         loading: () => CircularLoading(),
                //         error: (error, stackTrace) =>
                //             ErrorMessage(message: '${error}'),
                //       ),
                //       CustomRoundButton(
                //         text: '더보기',
                //         onTap: () {},
                //       ),
                //       const SizedBox(height: 12),
                //     ],
                //   ),
                // ),
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
