import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/constant/dimen.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatefulWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  @override
  _ScaffoldWithNestedNavigationState createState() =>
      _ScaffoldWithNestedNavigationState();
}

class _ScaffoldWithNestedNavigationState
    extends State<ScaffoldWithNestedNavigation> {
  // 인덱스 기록을 위한 배열
  List<int> navigationHistory = [];

  // 앱 종료 여부를 확인하기 위한 플래그
  bool _isExitWarningShown = false;

  void _goBranch(int index) {
    // 현재 인덱스가 동일하지 않을 때만 배열에 추가
    if (widget.navigationShell.currentIndex != index) {
      navigationHistory.add(widget.navigationShell.currentIndex);
    }
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 네비게이션 히스토리에 인덱스가 남아 있는 경우
        if (navigationHistory.isNotEmpty) {
          final previousIndex = navigationHistory.removeLast();
          widget.navigationShell.goBranch(previousIndex);
          return false; // 기본 pop 동작 방지
        }
        // 히스토리가 비어 있고, 최초 인덱스인 경우
        else if (widget.navigationShell.currentIndex == 0) {
          if (_isExitWarningShown) {
            // 한 번 더 뒤로가기를 눌렀을 때 앱 종료
            return true; // true를 반환하여 앱을 종료
          } else {
            // 최초의 뒤로가기로 앱 종료 경고를 한 번 표시
            _isExitWarningShown = true;

            // 2초 후에 경고 플래그를 리셋
            Future.delayed(Duration(seconds: 2), () {
              _isExitWarningShown = false;
            });

            // 사용자에게 안내 메시지 표시
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('\'뒤로\'버튼을 한번 더 누르면 종료됩니다.'),
              ),
            );
            return false; // 앱 종료를 방지
          }
        }
        return true; // 다른 경우에는 기본 동작
      },
      child: ScaffoldWithNavigationBar(
        body: widget.navigationShell,
        currentIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          if (index != widget.navigationShell.currentIndex) {
            _goBranch(index);
          }
        },
      ),
    );
  }
}

class ScaffoldWithNavigationBar extends StatelessWidget {
  const ScaffoldWithNavigationBar({
    super.key,
    required this.body,
    required this.currentIndex,
    required this.onDestinationSelected,
  });

  final Widget body;
  final int currentIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: Container(
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: Border(
            top: BorderSide(
              color: AppColors.grey,
              width: 0.0,
            ),
          ),
        ),
        child: NavigationBar(
          height: Dimen.navBottomHeight,
          backgroundColor: Colors.white,
          selectedIndex: currentIndex,
          indicatorColor: AppColors.greyBackground,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          destinations: [
            NavigationDestination(
              icon: Image.asset(
                Assets.home,
                width: 24,
                height: 24,
              ),
              selectedIcon: Image.asset(
                Assets.home,
                width: 24,
                height: 24,
              ),
              label: '홈',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.search,
                width: 24,
                height: 24,
              ),
              selectedIcon: Image.asset(
                Assets.search,
                width: 24,
                height: 24,
              ),
              label: '검색',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.heart,
                width: 24,
                height: 24,
              ),
              selectedIcon: Image.asset(
                Assets.heart,
                width: 24,
                height: 24,
              ),
              label: '좋아요',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.mypage,
                width: 24,
                height: 24,
              ),
              selectedIcon: Image.asset(
                Assets.mypage,
                width: 24,
                height: 24,
              ),
              label: '내정보',
            ),
          ],
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}