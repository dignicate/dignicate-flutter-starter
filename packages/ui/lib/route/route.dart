import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
class LaunchRoute extends GoRouteData {
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
    TypedStatefulShellBranch<WalletBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<WalletRoute>(path: WalletRoute.path),
      ],
    ),
    TypedStatefulShellBranch<NotificationBranchData>(
      routes: <TypedRoute<RouteData>>[
        TypedGoRoute<NotificationRoute>(path: NotificationRoute.path),
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
class WalletBranchData extends StatefulShellBranchData {
  const WalletBranchData();
}

@immutable
class NotificationBranchData extends StatefulShellBranchData {
  const NotificationBranchData();
}

@immutable
class MenuBranchData extends StatefulShellBranchData {
  const MenuBranchData();
}

@immutable
class HomeRoute extends GoRouteData {
  const HomeRoute();
  static const path = '/home';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Home'),
      ),
    );
  }
}

@immutable
class WalletRoute extends GoRouteData {
  const WalletRoute();
  static const path = '/wallet';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Wallet'),
      ),
    );
  }
}

@immutable
class NotificationRoute extends GoRouteData {
  const NotificationRoute();
  static const path = '/notification';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Notification'),
      ),
    );
  }
}

@immutable
class MenuRoute extends GoRouteData {
  const MenuRoute();
  static const path = '/menu';

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const Scaffold(
      body: Center(
        child: Text('Menu'),
      ),
    );
  }
}
