import 'package:flutter/material.dart';
import 'package:cookfluencer/common/constant/app_colors.dart';
import 'package:cookfluencer/common/constant/assets.dart';
import 'package:cookfluencer/common/constant/dimen.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));

  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldWithNavigationBar(
      body: navigationShell,
      currentIndex: navigationShell.currentIndex,
      onDestinationSelected: _goBranch,
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
          // labelBehavior: NavigationDestinationLabelBehavior.alwaysHide, // 라벨 숨기기
          destinations: [
            NavigationDestination(
              icon: Image.asset(
                Assets.home,
                width: 18,
                height: 18,
                color: AppColors.grey,
              ),
              selectedIcon: Image.asset(
                Assets.home,
                width: 18,
                height: 18,
              ),
              label: '홈',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.search,
                width: 16,
                height: 16,
                color: AppColors.grey,
              ),
              selectedIcon: Image.asset(
                Assets.search,
                width: 16,
                height: 16,
              ),
              label: '검색',
            ),
            NavigationDestination(
              icon: Image.asset(
                Assets.heart,
                width: 16,
                height: 16,
                color: AppColors.grey,
              ),
              selectedIcon: Image.asset(
                Assets.heart,
                width: 16,
                height: 16,
              ),
              label: '북마크',
            ),
          ],
          onDestinationSelected: onDestinationSelected,
        ),
      ),
    );
  }
}