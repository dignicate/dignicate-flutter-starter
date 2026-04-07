import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class LaunchScreen extends HookWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ViewModel などの DI は別の手段に置き換えるため、一旦削除
    // final notifier = ref.read(launchViewModelProvider.notifier);
    // final coordinator = Coordinator.instance;

    useEffect(() {
      // notifier.onCreate();
      return null;
    }, const []);

    useEffect(() {
      /*
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
      */
      return null;
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
