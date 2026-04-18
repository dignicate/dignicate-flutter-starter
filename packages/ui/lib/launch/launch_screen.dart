import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:ui/route/coordinator.dart';
import 'package:ui/route/route.dart';

class LaunchScreen extends HookWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      Future.microtask(() => Coordinator.of(context).goToHome(context));
      return null;
    }, const []);

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
