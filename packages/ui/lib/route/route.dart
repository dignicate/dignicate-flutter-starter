import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/common/app_config.dart';
import 'package:ui/common/app_drawer.dart';
import 'package:ui/common/custom_app_bar.dart';
import 'package:ui/features/home/home_navigation_container.dart';
import 'package:ui/debug/debug_menu_screen.dart';
import 'package:ui/launch/launch_screen.dart';

part 'route.g.dart';

final goRouter = GoRouter(
  initialLocation: '/launch',
  routes: $appRoutes,
);

@TypedGoRoute<LaunchRoute>(
  path: LaunchRoute.path,
)
@immutable
class LaunchRoute extends GoRouteData with $LaunchRoute {
  const LaunchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LaunchScreen();
  }

  static const path = '/launch';
}

@TypedGoRoute<SettingsRoute>(
  path: SettingsRoute.path,
)
@immutable
class SettingsRoute extends GoRouteData with $SettingsRoute {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(child: Text('Settings Screen (Dummy)')),
    );
  }

  static const path = '/settings';
}

@TypedGoRoute<DebugMenuRoute>(
  path: DebugMenuRoute.path,
)
@immutable
class DebugMenuRoute extends GoRouteData with $DebugMenuRoute {
  const DebugMenuRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const DebugMenuScreen();
  }

  static const path = '/debug';
}

@TypedStatefulShellRoute<HomeNavigationContainerRoute>(
  branches: <TypedStatefulShellBranch<StatefulShellBranchData>>[
    TypedStatefulShellBranch<HomeBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<HomeRoute>(path: HomeRoute.path),
      ],
    ),
    TypedStatefulShellBranch<CatalogBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<CatalogRoute>(path: CatalogRoute.path),
      ],
    ),
    TypedStatefulShellBranch<SavedBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<SavedRoute>(path: SavedRoute.path),
      ],
    ),
    TypedStatefulShellBranch<MenuBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<MenuRoute>(path: MenuRoute.path),
      ],
    ),
  ],
)
@immutable
class HomeNavigationContainerRoute extends StatefulShellRouteData {
  const HomeNavigationContainerRoute();

  @override
  Widget builder(
    BuildContext context,
    GoRouterState state,
    StatefulNavigationShell navigationShell,
  ) {
    return HomeNavigationContainer(
      navigationShell: navigationShell,
    );
  }
}

@immutable
class HomeBranchData extends StatefulShellBranchData {
  const HomeBranchData();
}

@immutable
class CatalogBranchData extends StatefulShellBranchData {
  const CatalogBranchData();
}

@immutable
class SavedBranchData extends StatefulShellBranchData {
  const SavedBranchData();
}

@immutable
class MenuBranchData extends StatefulShellBranchData {
  const MenuBranchData();
}

@immutable
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();
  static const path = '/home';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final config = AppConfigScope.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Home',
        showsMenuButton: true,
      ),
      drawer: AppDrawer(
        version: config.version,
        showsDebugMenu: config.showsDebugMenu,
      ),
      body: const Center(
        child: Text('Home'),
      ),
    );
  }
}

@immutable
class CatalogRoute extends GoRouteData with $CatalogRoute {
  const CatalogRoute();
  static const path = '/catalog';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final config = AppConfigScope.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Catalog',
        showsMenuButton: true,
      ),
      drawer: AppDrawer(
        version: config.version,
        showsDebugMenu: config.showsDebugMenu,
      ),
      body: const Center(
        child: Text('Catalog'),
      ),
    );
  }
}

@immutable
class SavedRoute extends GoRouteData with $SavedRoute {
  const SavedRoute();
  static const path = '/saved';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final config = AppConfigScope.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Saved',
        showsMenuButton: true,
      ),
      drawer: AppDrawer(
        version: config.version,
        showsDebugMenu: config.showsDebugMenu,
      ),
      body: const Center(
        child: Text('Saved (Empty State)'),
      ),
    );
  }
}

@immutable
class MenuRoute extends GoRouteData with $MenuRoute {
  const MenuRoute();
  static const path = '/menu';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final config = AppConfigScope.of(context);
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Menu',
        showsMenuButton: true,
      ),
      drawer: AppDrawer(
        version: config.version,
        showsDebugMenu: config.showsDebugMenu,
      ),
      body: const Center(
        child: Text('Menu'),
      ),
    );
  }
}

