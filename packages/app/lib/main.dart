import 'package:app/prod_deps.dart';
import 'package:flutter/material.dart';
import 'package:core/utils/logger_util.dart';
import 'package:ui/common/app_config.dart';
import 'package:ui/route/coordinator.dart';
import 'package:ui/route/route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    final config = await AppConfig.load();
    runApp(TheApp(config: config));
  } catch (e, stackTrace) {
    logger.e('Failed to initialize app', error: e, stackTrace: stackTrace);
    rethrow;
  }
}

class TheApp extends StatelessWidget {
  final AppConfig config;

  const TheApp({
    super.key,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfigScope(
      config: config,
      child: MaterialApp.router(
        routerConfig: goRouter,
        builder: (context, child) {
          return CoordinatorProvider(
            coordinator: const Coordinator(),
            child: child!,
          );
        },
      ),
    );
  }
}
