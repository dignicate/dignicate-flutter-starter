import 'package:app/prod_deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:core/utils/logger_util.dart';
import 'package:ui/route/coordinator.dart';
import 'package:ui/route/route.dart';

Future<void> main() async {
  const env = String.fromEnvironment('ENV', defaultValue: 'UNKNOWN');
  try {
    await dotenv.load(fileName: 'config/.env.$env', isOptional: true);
  } catch (e, stackTrace) {
    logger.e(e, stackTrace: stackTrace);
    logger.e("Given ENV is $env. \nENV must be one of [prod, stg, dev]");
    rethrow;
  }

  runApp(const TheApp());
}

class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouter,
      builder: (context, child) {
        return CoordinatorProvider(
          coordinator: const Coordinator(),
          child: child!,
        );
      },
    );
  }
}
