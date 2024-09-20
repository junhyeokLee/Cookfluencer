import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/ui/widget/search/ResultSearch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SearchResultScreen extends HookConsumerWidget {
  final String? resultSearch; // 키워드를 받을 수 있는 변수
  SearchResultScreen({Key? key, this.resultSearch}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return WillPopScope(
      onWillPop: () {
        if (GoRouter.of(context).canPop()) {
          // pop 대신 go를 사용해 애니메이션을 적용
          GoRouter.of(context).go('/home');
        } else {
          GoRouter.of(context).go('/home');
        }
        return Future.value(false); // 기본적으로 뒤로 가기 막기
      },
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false, // 기본 뒤로 가기 버튼을 숨김
            title: Container(
              decoration: BoxDecoration(
                border:
                    Border(bottom: BorderSide(color: AppColors.grey)), // 밑줄 추가
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: AppColors.black),
                    onPressed: () {
                      GoRouter.of(context).go('/home');
                    },
                  ),
                  Expanded(
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(resultSearch!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: ResultSearch(searchQuery: resultSearch!) // showFinalResults가 true일 때 표시할 화면

          ),
    );
  }
}
