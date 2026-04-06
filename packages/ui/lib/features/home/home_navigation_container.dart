import 'package:ui/common/icon_with_badge.dart';
import 'package:viewmodel/viewmodel_module.dart';
import 'package:ui/route/module.dart';
import 'package:flutter/material.dart';
import 'package:core/extension/theme_extension.dart';
import 'package:core/r.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeNavigationContainer extends HookConsumerWidget {
  final Widget child;
  const HomeNavigationContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coordinator = ref.read(coordinatorProvider);

    useEffect(() {
      // notifier.onCreate();
      return null;
    }, const[]);

    final currentIndex = useState(0);
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex.value,
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFFFFFFF),
        backgroundColor: Theme.of(context).navigationBackground,
        items: [
          BottomNavigationBarItem(
            icon: R.image.ic_bottom_nav_home,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: R.image.,
            label: '',
          ),
          BottomNavigationBarItem(
            icon: IconWithBadge(
              icon: R.image.,
              badgeCount: state.unreadCount ?? 0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: R.image.ic_bottom_nav_menu,
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
