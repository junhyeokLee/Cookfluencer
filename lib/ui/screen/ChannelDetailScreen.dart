import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/ui/widget/common/ChannelItemHorizontal.dart';
import 'package:cookfluencer/ui/widget/search/SearchBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChannelDetailScreen extends HookConsumerWidget {
  final ChannelData channelData; // 채널 데이터를 받는 파라미터

  const ChannelDetailScreen({
    Key? key,
    required this.channelData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final searchController = useTextEditingController(); // TextEditingController 생성
    final searchQuery = useState<String>(''); // 검색 쿼리 상태 관리
    final recentSearches = useState<List<String>>([]); // 최근 검색어 상태 관리
    final showSearchWidgets = useState<bool>(false); // 검색 위젯 보이기 여부
    final showFinalResults = useState<bool>(true); // 최종 검색 결과 화면 제어

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼을 숨김
        title: SearchBarWidget(
          searchQuery: searchQuery,
          searchController: searchController,
          recentSearches: recentSearches,
          onSearchTap: () {
            showSearchWidgets.value = true; // 자동 검색 화면 활성화
            showFinalResults.value = false; // 최종 검색 결과 숨기기
          },
          onBackPressed: () {
            GoRouter.of(context).pop();
            searchQuery.value = ''; // 검색 쿼리 초기화
            searchController.clear(); // 검색 컨트롤러 초기화
          },
          showBackButton: true,
          // 뒤로가기 버튼 표시 여부
          onSubmitted: () {
            // 검색 완료 시
            showSearchWidgets.value = false; // 자동 검색 화면 숨기기
            showFinalResults.value = true; // 최종 검색 결과 화면 보이기
          },
          enabled: true, // ResultSearch가 true일 때 enabled 설정
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(left: 16, top: 24),
            child: Text('인플루언서',
                style: Theme.of(context).textTheme.labelLarge),
          ),

              ChannelItemHorizontal(channelData: channelData),
        ],
      ),
    );
  }
}