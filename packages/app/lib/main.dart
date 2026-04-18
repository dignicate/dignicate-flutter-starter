import 'package:app/prod_deps.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:core/utils/logger_util.dart';
import 'package:ui/route/route.dart';

Future<void> main() async {
  const env = String.fromEnvironment('ENV', defaultValue: 'UNKNOWN');
  try {
    await dotenv.load(fileName: 'config/.env.$env');
  } catch (e, stackTrace) {
    logger.e(e, stackTrace: stackTrace);
    logger.e("Given ENV is $env. \nENV must be one of [prod, stg, dev]");
    rethrow;
  }

  // DataStore は共有して再利用
  // final xxxDataStore = xxxDataStore();

  // DI は別の手段に置き換えるため、ProviderScope を削除
  runApp(const TheApp());
}

class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    // createAppRouter を呼び出して MaterialApp.router を遅延生成します。
    return createAppRouter();
  }
}
