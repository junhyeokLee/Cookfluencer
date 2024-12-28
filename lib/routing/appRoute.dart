import 'package:cookfluencer/data/channelData.dart';
import 'package:cookfluencer/routing/scaffold_with_nested_navigation.dart';
import 'package:cookfluencer/ui/screen/ChannelDetailScreen.dart';
import 'package:cookfluencer/ui/screen/HomeScreen.dart';
import 'package:cookfluencer/ui/screen/LikeScreen.dart';
import 'package:cookfluencer/ui/screen/MyPageScreen.dart';
import 'package:cookfluencer/ui/screen/HomeSearchScreen.dart';
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
  channelDetail,
  videoDetail,
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
              GoRoute(
                path: '/home',
                name: AppRoute.home.name,
                builder: (context, state) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: 'channelDetail',
                    name: AppRoute.channelDetail.name,
                    builder: (context, state) {
                      final channelData = state.extra as ChannelData;
                      return ChannelDetailScreen(channelData: channelData);
                    },
                  ),
                  GoRoute(
                    path: ':keyword',
                    name: AppRoute.homeKeyword.name,
                    builder: (context, state) {
                      final keyword = state.pathParameters['keyword'] as String;
                      return HomeSearchScreen(resultSearch: keyword);
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
                builder: (context, state) =>  SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _likeNavigatorKey,
            routes: [
              GoRoute(
                path: '/like',
                name: AppRoute.like.name,
                builder: (context, state) => const LikeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _mypageNavigatorKey,
            routes: [
              GoRoute(
                path: '/mypage',
                name: AppRoute.mypage.name,
                builder: (context, state) => const MyPageScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});


Widget _defaultTransitionBuilder(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) {
  const begin = Offset(1.0, 0.0); // 화면 오른쪽에서 시작
  const end = Offset.zero; // 화면 중심으로 이동
  const curve = Curves.easeInOut;

  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  var offsetAnimation = animation.drive(tween);

  return SlideTransition(
    position: offsetAnimation,
    child: child,
  );
}
