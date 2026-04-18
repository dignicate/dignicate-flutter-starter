import 'package:app/prod_deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:core/utils/logger_util.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ui/common/app_config.dart';
import 'package:ui/route/coordinator.dart';
import 'package:ui/route/route.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  const env = String.fromEnvironment('ENV', defaultValue: 'UNKNOWN');
  try {
    await dotenv.load(fileName: 'config/.env.$env', isOptional: true);
  } catch (e, stackTrace) {
    logger.e(e, stackTrace: stackTrace);
    logger.e("Given ENV is $env. \nENV must be one of [prod, stg, dev]");
    rethrow;
  }

  final packageInfo = await PackageInfo.fromPlatform();
  final version = packageInfo.version;

  runApp(TheApp(version: version));
}

class TheApp extends StatelessWidget {
  final String version;

  const TheApp({
    super.key,
    required this.version,
  });

  @override
  Widget build(BuildContext context) {
    return AppConfig(
      version: version,
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
