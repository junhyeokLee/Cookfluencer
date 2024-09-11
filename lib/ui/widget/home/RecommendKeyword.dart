import 'package:cached_network_image/cached_network_image.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/ui/widget/home/RecommendKeywordlVideo.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart'; // useState를 사용하기 위해 추가

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
    final scrollController = useScrollController(); // 스크롤 컨트롤러 추가

    return SingleChildScrollView( // 전체 스크롤 가능하도록 SingleChildScrollView 사용
      controller: scrollController, // 스크롤 컨트롤러 설정
      child: keywordListAsyncValue.when(
        data: (keywords) {
          if (keywords.isEmpty) {
            return const Text('키워드가 없습니다.');
          }

          // 첫 번째 키워드를 기본 선택값으로 설정
          if (selectedKeyword.value == null) {
            selectedKeyword.value = (keywords.first.data() as Map<String, dynamic>)['name']; // 첫 번째 키워드 설정
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start, // 텍스트를 왼쪽 정렬
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 24, bottom: 12),
                child: Text('추천 키워드', style: Theme.of(context).textTheme.labelLarge),
              ),
              SizedBox(
                height: 30, // 가로 스크롤 리스트 높이를 고정
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24), // 좌우로 패딩 추가
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal, // 가로 스크롤
                    clipBehavior: Clip.none, // 스크롤할 때 좌우가 짤리지 않도록 설정
                    itemCount: keywords.length,
                    itemBuilder: (context, index) {
                      // 데이터 타입을 Map<String, dynamic>으로 캐스팅
                      final keyword = keywords[index].data() as Map<String, dynamic>;
                      final isSelected = selectedKeyword.value == keyword['name']; // 선택 여부 확인

                      return GestureDetector(
                        onTap: () {
                          // 동일한 키워드는 다시 선택할 수 없고, 다른 키워드만 선택 가능
                          if (selectedKeyword.value != keyword['name']) {
                            selectedKeyword.value = keyword['name']; // 새로운 키워드 선택
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8), // 간격 조정
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.grey : AppColors.greyBackground, // 선택되면 배경색 변경
                            borderRadius: BorderRadius.circular(50), // 둥근 사각형 (양옆과 위아래가 둥근 형태)
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12, right: 12), // 내부 패딩
                            child: Center(
                              child: Text(
                                keyword['name'] ?? '', // null 체크 후 텍스트 표시
                                maxLines: 1, // 한 줄로 제한
                                overflow: TextOverflow.ellipsis, // 길어질 경우 생략
                                style: TextStyle(
                                  color: isSelected ? Colors.white : AppColors.black, // 선택 여부에 따라 텍스트 색 변경
                                  fontSize: 12, // 글자 크기
                                  fontFamily: GoogleFonts.nanumGothic().fontFamily, // 글자 폰트
                                  fontWeight: FontWeight.w500, // 글자 굵기
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (selectedKeyword.value != null) // 선택된 키워드가 있을 때만 아래 리스트 표시
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecommendKeywordVideos(keywrod: selectedKeyword.value!), // 선택된 키워드에 대한 비디오 리스트
                      Material(
                        color: AppColors.greyBackground, // 컨테이너 배경색
                        borderRadius: BorderRadius.circular(50), // 둥근 모서리
                        child: InkWell(
                          onTap: () {

                          },
                          splashColor: AppColors.grey.withOpacity(0.5), // 리플 효과 색상
                          highlightColor: AppColors.grey.withOpacity(0.3), // 클릭 시의 배경 색상
                          borderRadius: BorderRadius.circular(50), // 둥근 모서리
                          child: Container(
                            alignment: Alignment.center,
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12), // 버튼의 패딩
                            child: Text(
                              '더보기',
                              style: TextStyle(
                                color: AppColors.black,
                                fontSize: 14,
                                fontFamily: GoogleFonts.nanumGothic().fontFamily,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
            ],
          );
        },
        loading: () => const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.greyBackground),
        ),
        error: (error, stack) => Text('키워드 로드 중 오류 발생: $error'),
      ),
    );
  }
}