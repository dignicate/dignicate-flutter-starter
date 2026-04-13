import 'package:logger/logger.dart' as logger_impl;

/// アプリ全体で使用するロガー。
/// 特定のログライブラリへの依存を隠蔽するためのラッパーです。
final logger = AppLogger();

class AppLogger {
  final _logger = logger_impl.Logger(
    filter: logger_impl.ProductionFilter(),
    printer: logger_impl.PrettyPrinter(),
  );

  void t(String message) => _logger.t(message);
  void d(String message) => _logger.d(message);
  void i(String message) => _logger.i(message);
  void w(String message) => _logger.w(message);
  void e(dynamic message, {dynamic error, StackTrace? stackTrace}) =>
      _logger.e(message, error: error, stackTrace: stackTrace);
  void f(String message) => _logger.f(message);
}
