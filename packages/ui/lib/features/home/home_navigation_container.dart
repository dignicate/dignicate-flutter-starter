import 'package:ui/common/icon_with_badge.dart';
import 'package:flutter/material.dart';
import 'package:core/extension/theme_extension.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeNavigationContainer extends HookWidget {
  final Widget child;
  const HomeNavigationContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Coordinator などの DI は別の手段に置き換えるため、一旦削除
    // final coordinator = Coordinator.instance;

    useEffect(() {
      // notifier.onCreate();
      return null;
    }, const []);

    final currentIndex = useState(0);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.value,
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFFFFFFF),
        backgroundColor: Theme.of(context).navigationBackground,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: IconWithBadge(
              icon: Icon(Icons.notifications),
              badgeCount: 0,
            ),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
        onTap: (index) {
          currentIndex.value = index;
          switch (index) {
            case 0:
              // coordinator.goToTopTab(context);
              break;
            case 1:
              // coordinator.
              break;
            case 2:
              // coordinator.
              break;
            case 3:
              // coordinator.
              break;
          }
        },
      ),
    );
  }
}
