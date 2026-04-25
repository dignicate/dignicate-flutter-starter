import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// 実行環境の定義
enum AppEnvironment {
  production('prod'),
  staging('stg'),
  development('dev'),
  unknown('UNKNOWN');

  final String name;
  const AppEnvironment(this.name);

  factory AppEnvironment.fromName(String name) => switch (name) {
        'prod' => production,
        'stg' => staging,
        'dev' => development,
        _ => unknown,
      };

  bool get isProduction => this == production;
}

/// アプリ全体の設定情報を保持するデータクラス
class AppConfig {
  final String version;
  final AppEnvironment env;
  final String packageName;

  AppConfig({
    required this.version,
    required this.env,
    required this.packageName,
  });

  /// デバッグメニューを表示可能かどうか
  bool get showsDebugMenu => !env.isProduction;

  /// 起動時の初期化ロジックを一括管理
  static Future<AppConfig> load() async {
    const envName = String.fromEnvironment('ENV', defaultValue: 'UNKNOWN');
    final env = AppEnvironment.fromName(envName);
    
    // .env のロード
    await dotenv.load(fileName: 'config/.env.${env.name}', isOptional: true);
    
    // パッケージ情報の取得
    final packageInfo = await PackageInfo.fromPlatform();
    
    return AppConfig(
      version: packageInfo.version,
      env: env,
      packageName: packageInfo.packageName,
    );
  }
}

/// AppConfig をウィジェットツリーに提供する InheritedWidget
class AppConfigScope extends InheritedWidget {
  final AppConfig config;

  const AppConfigScope({
    super.key,
    required this.config,
    required super.child,
  });

  static AppConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfigScope>()?.config;
  }

  static AppConfig of(BuildContext context) {
    final result = maybeOf(context);
    assert(result != null, 'No AppConfigScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppConfigScope oldWidget) {
    return config.version != oldWidget.config.version || 
           config.env != oldWidget.config.env ||
           config.packageName != oldWidget.config.packageName;
  }
}
