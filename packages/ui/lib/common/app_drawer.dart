import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/extension/theme_extension.dart';
import 'package:ui/common/app_config.dart';
import 'package:ui/route/coordinator.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.version,
    this.showsDebugMenu = false,
  });

  final String version;
  final bool showsDebugMenu;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.appBarTitle;
    final coordinator = Coordinator.of(context);
    
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).navigationBackground,
            ),
            child: Center(
              child: Text(
                'Menu',
                style: textStyle.copyWith(color: Colors.black),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              coordinator.goToSettings(context);
            },
          ),
          if (showsDebugMenu)
            ListTile(
              leading: const Icon(Icons.bug_report),
              title: const Text('Debug Menu'),
              onTap: () {
                Navigator.pop(context);
                coordinator.goToDebugMenu(context);
              },
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'v$version',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}


