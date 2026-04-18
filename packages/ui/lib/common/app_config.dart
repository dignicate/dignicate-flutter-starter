import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String version;

  const AppConfig({
    super.key,
    required this.version,
    required super.child,
  });

  static AppConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  static AppConfig of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No AppConfig found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppConfig oldWidget) {
    return version != oldWidget.version;
  }
}
