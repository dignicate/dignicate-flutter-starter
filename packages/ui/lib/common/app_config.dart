import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// アプリ全体の設定情報を保持するデータクラス
class AppConfig {
  final String version;
  final String env;

  AppConfig({
    required this.version,
    required this.env,
  });

  /// 起動時の初期化ロジックを一括管理
  static Future<AppConfig> load() async {
    const env = String.fromEnvironment('ENV', defaultValue: 'UNKNOWN');
    
    // .env のロード
    await dotenv.load(fileName: 'config/.env.$env', isOptional: true);
    
    // パッケージ情報の取得
    final packageInfo = await PackageInfo.fromPlatform();
    
    return AppConfig(
      version: packageInfo.version,
      env: env,
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
           config.env != oldWidget.config.env;
  }
}
