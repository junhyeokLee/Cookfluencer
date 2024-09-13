import 'package:cookfluencer/common/SlideTransition.dart';
import 'package:cookfluencer/routing/scaffold_with_nested_navigation.dart';
import 'package:cookfluencer/ui/screen/ChannelsScreen.dart';
import 'package:cookfluencer/ui/screen/HomeScreen.dart';
import 'package:cookfluencer/ui/screen/LikeScreen.dart';
import 'package:cookfluencer/ui/screen/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  search,
  like,
  channels,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _bookmarkNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'bookmark');

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/home',
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: true,
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              // 홈 화면
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const HomeScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _searchNavigatorKey,
            routes: [
              GoRoute(
                path: '/search',
                name: AppRoute.search.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: SearchScreen(),
                ),
              ),
              // ChannelsTotalScreen 라우트 추가
              GoRoute(
                path: '/channels',
                name: AppRoute.channels.name,
                pageBuilder: (context, state) {
                  final searchQuery = state.pathParameters['searchQuery'] as String;;
                  // 애니메이션 적용
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: ChannelsScreen(searchQuery: searchQuery),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return SlideAnimation(animation, child); // 슬라이드 애니메이션에 지속 시간 적용
                    },
                    transitionDuration: const Duration(milliseconds: 300), // 애니메이션 속도 조절
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _bookmarkNavigatorKey,
            routes: [
              // 좋아요 화면
              GoRoute(
                path: '/like',
                name: AppRoute.like.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const LikeScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});