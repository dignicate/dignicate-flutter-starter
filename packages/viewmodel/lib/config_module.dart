import 'package:core/config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final configProvider = Provider<Config>((ref) {
  throw UnimplementedError('configProvider must be overridden in main.dart');
});
