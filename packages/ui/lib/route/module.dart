import 'package:ui/route/route.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final coordinatorProvider = Provider<Coordinator>((ref) {
  return Coordinator.instance;
});
