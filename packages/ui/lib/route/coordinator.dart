import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/route/route.dart';

/// Coordinator handles all navigation logic.
/// It decouples the UI from the underlying routing library (GoRouter).
class Coordinator {
  const Coordinator();

  /// Access the Coordinator from the widget tree.
  static Coordinator of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<CoordinatorProvider>();
    return provider?.coordinator ?? const Coordinator();
  }

  void goToLaunch(BuildContext context) {
    const LaunchRoute().go(context);
  }

  void goToHome(BuildContext context) {
    const HomeRoute().go(context);
  }

  void goToCatalog(BuildContext context) {
    const CatalogRoute().go(context);
  }

  void goToSaved(BuildContext context) {
    const SavedRoute().go(context);
  }

  void goToMenu(BuildContext context) {
    const MenuRoute().go(context);
  }

  void goToSettings(BuildContext context) {
    const SettingsRoute().push(context);
  }

  void pop(BuildContext context) {
    context.pop();
  }
}

/// InheritedWidget to provide the Coordinator to the widget tree.
class CoordinatorProvider extends InheritedWidget {
  const CoordinatorProvider({
    super.key,
    required this.coordinator,
    required super.child,
  });

  final Coordinator coordinator;

  @override
  bool updateShouldNotify(CoordinatorProvider oldWidget) =>
      coordinator != oldWidget.coordinator;
}
