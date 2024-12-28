import 'package:cookfluencer/common/CircularLoading.dart';
import 'package:cookfluencer/common/EmptyMessage.dart';
import 'package:cookfluencer/common/ErrorMessage.dart';
import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/provider/ChannelProvider.dart';
import 'package:cookfluencer/provider/SearchProvider.dart';
import 'package:cookfluencer/ui/widget/search/AutoSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch3.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearchChannel.dart';
import 'package:cookfluencer/ui/widget/search/TotalChannels.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../widget/search/ResultSearchAlgoria.dart';

class HomeSearchScreen extends HookConsumerWidget {
  final String? resultSearch; // 키워드를 받을 수 있는 변수
  HomeSearchScreen({Key? key, this.resultSearch}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController(); // TextEditingController 생성
    final searchQuery = useState<String>(resultSearch!); // 검색 쿼리 상태 관리
    final recentSearches = useState<List<String>>([]); // 최근 검색어 상태 관리
    final showSearchWidgets = useState<bool>(false); // 검색 위젯 보이기 여부
    final showFinalResults = useState<bool>(true); // 최종 검색 결과 화면 제어
    final showRecentSearch = useState<bool>(true);
    final showChannelDetail = useState<bool>(false);
    final showTotalChannel = useState<bool>(false);
    final selectedChannelData = useState<ChannelData?>(null);
    final selectedTotalChannel = useState<String>('');

    // 키보드 닫는 기능 추가
    void _dismissKeyboard() {
      FocusScope.of(context).unfocus();
    }

    final fb_searchResult = ref.watch(autoSearchChannelAndVideoProvider(searchQuery.value));

    return GestureDetector(
      onTap: _dismissKeyboard, // 화면 터치 시 키보드 닫기
      child: Scaffold(
          // appBar: AppbarWidget(), // 앱바 추가
          body: Column(
              children: [
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (Widget child, Animation<double> animation) {
                      return _buildSlideTransition(child, animation);
                    },
                    child:
                    showTotalChannel.value
                        ? Totalchannels(
                            searchQuery: selectedTotalChannel.value,
                            onChannelItemClick: (channelData) {
                              showTotalChannel.value = false;
                              selectedChannelData.value = channelData;
                              showChannelDetail.value = true;
                            },
                          )
                        : showChannelDetail.value
                            ? ResultSearchChannel(
                                key: ValueKey(selectedChannelData.value?.id),
                                channelData: selectedChannelData.value!,
                              )
                            : showFinalResults.value
                                ? ResultSearchAlgoria(
                      key: ValueKey(searchQuery.value),
                      searchQuery: searchQuery.value,

                      onChannelItemClick: (channelData) {
                        // selectedChannelData.value = channelData;
                        // showChannelDetail.value = true;
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => ResultSearchChannel(
                              channelData: channelData,
                            ),
                          ),
                        );
                      },
                      onTotalChannelClick: (String) {
                        // selectedTotalChannel.value = String;
                        // showTotalChannel.value = true;
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (context) => Totalchannels(
                              searchQuery: String,
                              onChannelItemClick: (channelData) {
                                Navigator.of(context).push(
                                  CupertinoPageRoute(
                                    builder: (context) => ResultSearchChannel(
                                      channelData: channelData,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ) : showSearchWidgets.value
                                    ? fb_searchResult.when(
                                        data: (results) {
                                          // 검색 결과가 있는 경우
                                          // if (results.isEmpty) {
                                          //   return Padding(
                                          //     padding: const EdgeInsets.all(42),
                                          //     child: Center(
                                          //       child: EmptyMessage(
                                          //           message:
                                          //               '쿡플루언서 검색 결과가 없습니다.'), // 결과가 없을 때 메시지
                                          //     ),
                                          //   );
                                          // }
                                          return AutoSearch(
                                            key: ValueKey('autoSearch'),
                                            results: results,
                                            searchQuery: searchQuery,
                                            searchController: searchController,
                                            onSubmitted: () {
                                              // 엔터 누르기 동작을 처리
                                              showSearchWidgets.value = false;
                                              showFinalResults.value = true; // 최종 검색 결과 화면 보이기
                                              _navigateToResultsPage(context, searchQuery.value); // 결과 페이지로 이동
                                              searchQuery.value = "";
                                              searchController.clear();
                                            },
                                          ); // 검색 결과 위젯 반환
                                        },
                                        loading: () => CircularLoading(),
                                        error: (error, stackTrace) =>
                                            ErrorMessage(message: '${error}'),
                                      )
                                    : Container(),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  // 슬라이드 애니메이션 함수
  Widget _buildSlideTransition(Widget child, Animation<double> animation) {
    // 뒤로가기 시 애니메이션 방향을 역으로 설정
    // final offset = isBackwards ? Offset(-1.0, 0.0) : Offset(1.0, 0.0);
    // final slideAnimation = Tween<Offset>(begin: offset, end: Offset.zero).animate(animation);
    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInOut, // 부드러운 시작과 끝
      ),
    );
    return FadeTransition(
      opacity: fadeAnimation,
      child: child,
    );
    // return SlideTransition(
    //   position: slideAnimation,
    //   child: child,
    // );
  }
  void _navigateToResultsPage(BuildContext context, String searchQuery) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => ResultSearchAlgoria(
          searchQuery: searchQuery,
          onChannelItemClick: (channelData) {
            // 채널 클릭 시 채널 상세 페이지로 이동
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    ResultSearchChannel(
                      channelData: channelData,
                    ),
              ),
            );
          },
          onTotalChannelClick: (String totalChannel) {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    Totalchannels(
                      searchQuery: totalChannel,
                      onChannelItemClick: (channelData) {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) =>
                                ResultSearchChannel(
                                  channelData: channelData,
                                ),
                          ),
                        );
                      },
                    ),
              ),
            );
          },
        ),
      ),
    );
  }
}
