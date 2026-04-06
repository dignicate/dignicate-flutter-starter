import 'app_deps.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The single provider that must be overridden by the app's Composition Root.
///
/// App should create a concrete implementation (e.g. `ProdDeps implements AppDeps`)
/// and override this provider at app startup. The default implementation throws
/// so that forgetting to override becomes a loud runtime error immediately.

final appDepsProvider = Provider<AppDeps>((ref) {
  throw UnimplementedError('appDepsProvider must be overridden in app');
});
