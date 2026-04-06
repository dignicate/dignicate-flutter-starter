import 'package:app/prod_deps.dart';

Future<void> main() async {
  const env = String.fromEnvironment('ENV', defaultValue: 'UNKNOWN');
  try {
    await dotenv.load(fileName: 'config/.env.$env');
  } catch (e, stackTrace) {
    sharedLogger.e(e, stackTrace: stackTrace);
    sharedLogger.e("Given ENV is $env. \nENV must be one of [Prod,  Dev]");
    rethrow;
  }

  // DataStore は共有して再利用
  // final xxxDataStore = xxxDataStore();

  runApp(
    ProviderScope(
      overrides: [
        appDepsProvider.overrideWithValue(
          ProdDeps(
          ),
        ),
      ],
      child: const TheApp(),
    ),
  );
}

class TheApp extends StatelessWidget {
  const TheApp({super.key});

  @override
  Widget build(BuildContext context) {
    // createAppRouter を呼び出して MaterialApp.router を遅延生成します。
    return createAppRouter();
  }
}
