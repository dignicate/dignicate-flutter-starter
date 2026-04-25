import 'package:ui/common/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ui/common/app_config.dart';
import 'package:flutter/foundation.dart';

class DebugMenuScreen extends StatelessWidget {

  const DebugMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              children: const [
                // ListTile(
                //   title: Text(''),
                //   onTap: () {
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 開発者向けApp情報（Package Name, Version, Flavor）を表示するWidget
class _DebugAppInfoFooter extends StatelessWidget {
  const _DebugAppInfoFooter();

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return const SizedBox.shrink();
    
    final config = AppConfigScope.of(context);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(label: 'Package Name', value: config.packageName),
          _InfoRow(label: 'Version', value: config.version),
          _InfoRow(label: 'Environment', value: config.env),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

