import 'package:cookfluencer/routing/scaffold_with_nested_navigation.dart';
import 'package:cookfluencer/ui/screen/ChannelsScreen.dart';
import 'package:cookfluencer/ui/screen/HomeScreen.dart';
import 'package:cookfluencer/ui/screen/LikeScreen.dart';
import 'package:cookfluencer/ui/screen/MyPageScreen.dart';
import 'package:cookfluencer/ui/screen/SearchResultScreen.dart';
import 'package:cookfluencer/ui/screen/SearchScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

enum AppRoute {
  home,
  homeKeyword,
  search,
  like,
  mypage,
  channels,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _searchNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'search');
final _likeNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'like');
final _mypageNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'mypage');

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
                routes: [
                  GoRoute(
                    path: ':keyword',
                    name: AppRoute.homeKeyword.name,
                    pageBuilder: (context, state) {
                      final keyword = state.pathParameters['keyword'] as String;
                      return CustomTransitionPage(
                        key: state.pageKey,
                        child: SearchResultScreen(resultSearch: keyword),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;
                          final tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          final offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                        transitionDuration: const Duration(milliseconds: 300),
                      );
                    },
                  ),
                ],
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
                  final searchQuery =
                      state.pathParameters['searchQuery'] as String;
                  ;
                  // 애니메이션 적용
                  return CustomTransitionPage(
                    key: state.pageKey,
                    child: ChannelsScreen(searchQuery: searchQuery),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const begin = Offset(1.0, 0.0);
                      const end = Offset.zero;
                      const curve = Curves.easeInOut;
                      final tween = Tween(begin: begin, end: end)
                          .chain(CurveTween(curve: curve));
                      final offsetAnimation = animation.drive(tween);
                      return SlideTransition(
                        position: offsetAnimation,
                        child: child,
                      );
                    },
                  );
                },
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _likeNavigatorKey,
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
          StatefulShellBranch(
            navigatorKey: _mypageNavigatorKey,
            routes: [
              // 좋아요 화면
              GoRoute(
                path: '/mypage',
                name: AppRoute.mypage.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: const MyPageScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
