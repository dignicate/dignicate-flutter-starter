import 'package:ui/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter/foundation.dart';

class DebugMenuScreen extends StatelessWidget {

  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Coordinator などの DI は別の手段に置き換えるため、一旦削除
    // final coordinator = Coordinator.instance;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Debug Menu',
        showsBackButton: true,
      ),
      body: Column(
        children: [
          const _DebugAppInfoFooter(),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text(''),
                  onTap: () {
                    // coordinator.pushDebugCommonViewObjects(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 開発者向けApp情報（App ID, Flavor）を控えめに表示するWidget
class _DebugAppInfoFooter extends StatefulWidget {
  const _DebugAppInfoFooter();

  @override
  State<_DebugAppInfoFooter> createState() => _DebugAppInfoFooterState();
}

class _DebugAppInfoFooterState extends State<_DebugAppInfoFooter> {
  String? _appId;

  @override
  void initState() {
    super.initState();
    _loadInfo();
  }

  Future<void> _loadInfo() async {
    if (!kDebugMode) return;
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _appId = info.packageName;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    final appId = _appId;
    final displayText = (appId == null || appId.isEmpty)
        ? 'App ID: loading...'
        : 'App ID: $appId';
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 16, right: 16, bottom: 4),
      child: Align(
        alignment: .centerLeft,
        child: Text(
          displayText,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey,
                fontSize: 12,
              ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
