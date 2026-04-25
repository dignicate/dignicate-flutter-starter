import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:core/extension/theme_extension.dart';
import 'package:ui/common/app_config.dart';
import 'package:ui/route/coordinator.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.appBarTitle;
    final config = AppConfigScope.of(context);
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
          if (kDebugMode)
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'v${config.version}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                if (kDebugMode)
                  Text(
                    config.packageName,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

