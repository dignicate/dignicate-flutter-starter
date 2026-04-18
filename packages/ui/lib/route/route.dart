import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/common/custom_app_bar.dart';
import 'package:ui/features/home/home_navigation_container.dart';
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
    return const Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      body: Center(
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
    return const Scaffold(
      appBar: CustomAppBar(title: 'Catalog'),
      body: Center(
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
    return const Scaffold(
      appBar: CustomAppBar(title: 'Saved'),
      body: Center(
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
    return const Scaffold(
      appBar: CustomAppBar(title: 'Menu'),
      body: Center(
        child: Text('Menu'),
      ),
    );
  }
}
