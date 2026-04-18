import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void useAppLifecycleResume(VoidCallback onResume) {
  final context = useContext();

  useEffect(() {
    final observer = LifecycleEventHandler(
      onResume: () => onResume(),
    );

    WidgetsBinding.instance.addObserver(observer);

    return () => WidgetsBinding.instance.removeObserver(observer);
  }, [context]);
}

class LifecycleEventHandler extends WidgetsBindingObserver {
  final VoidCallback? onResume;

  LifecycleEventHandler({this.onResume});

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      onResume?.call();
    }
  }
}