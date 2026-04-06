import 'package:viewmodel/viewmodel_module.dart';
import 'package:viewmodel/launch/launch_view_model.dart';
import 'package:ui/route/module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class LaunchScreen extends HookConsumerWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(launchViewModelProvider.notifier);
    final coordinator = ref.read(coordinatorProvider);

    useEffect(() {
      notifier.onCreate();
      return null;
    }, const []);

    useEffect(() {
      final subscription = notifier.event.listen((event) {
        event.when(
            shouldGoToHome: () {
              // coordinator.goToTopTab(context);
            },
            shouldGoToLogin: () {
              // coordinator.goToLoginScreen(context);
            },
        );
      });
      return () => subscription.cancel();
    }, []);

    return Container(
      color: Colors.white,
      child: const Center(
        child: SizedBox(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
