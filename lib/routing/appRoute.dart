import 'package:cookfluencer/routing/scaffold_with_nested_navigation.dart';
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
  ;
  static AppRoute find(String? name) {
    return values.asNameMap()[name] ?? AppRoute.home;
  }
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
          debugPrint("상태 : "+state.toString());
          debugPrint("상태 currentIndex : "+navigationShell.currentIndex.toString());

          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              // Products
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
              // Shopping Cart
              GoRoute(
                path: '/search',
                name: AppRoute.search.name,
                pageBuilder: (context, state) => NoTransitionPage(
                  key: state.pageKey,
                  child: SearchScreen(),
                ),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: _bookmarkNavigatorKey,
            routes: [
              // Shopping Cart
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
