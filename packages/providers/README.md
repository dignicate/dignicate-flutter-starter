# providers package

このパッケージはアプリケーションの依存注入（DI）エントリを一箇所にまとめるための軽量パッケージです。

公開 API:
- AppDeps (abstract)
- appDepsProvider (Provider<AppDeps>)

運用ルール (重要):
- `providers` は data / app / ui を import してはならない。
- `providers` は domain と viewmodel に依存してよい。
- アプリ (app) は起動時に `ProdDeps` 等の具象実装を組み立て、`appDepsProvider` を override して注入します。
  例 (概念):

  ```dart
  final prodDeps = ProdDeps(...);
  runApp(
    ProviderScope(
      overrides: [
        appDepsProvider.overrideWithValue(prodDeps),
      ],
      child: const MyApp(),
    ),
  );
  ```

- `appDepsProvider` はデフォルト実装で `throw UnimplementedError` を返すため、override 忘れは起動時に検出されます。

目的:
- ui / viewmodel などが直接 data を参照しないようにし、依存関係を明確にする。
- DI (Dependency Injection) の override を一箇所に集約してミスを減らす。

