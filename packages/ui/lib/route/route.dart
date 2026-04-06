import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'route.g.dart';

/// `goRouter` was previously created as a top-level widget which caused
/// generation/initialization to run before `ProviderScope` overrides were
/// applied in `main.dart`. Create the app router lazily via this factory
/// so it can be constructed after providers are available.
Widget createAppRouter({Key? key}) {
  return MaterialApp.router(
    key: key,
    routerConfig: GoRouter(
      initialLocation: LaunchRoute.path,
      routes: $appRoutes,
    ),
  );
}

@TypedGoRoute<LaunchRoute>(
  path: LaunchRoute.path,
)
@immutable
class LaunchRoute extends GoRouteData with $LaunchRoute {
  const LaunchRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    sharedLogger.t('_LaunchRoute build');
    return const LaunchScreen();
  }

  static const path = '/launch';
}

/// xxxRoute クラスの存在を隠蔽して、画面遷移の手段を抽象化する
/// 特定のライブラリ（GoRouter）との結合度を下げる
class Coordinator {
  Coordinator._();

  static Coordinator get instance => Coordinator._();
}
