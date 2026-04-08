import 'package:flutter/material.dart';
import 'package:core/extension/theme_extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showsBackButton;
  final Object? backResult;
  final bool backToRootNavigator;
  final Color? backgroundColor;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showsBackButton = false,
    this.backResult,
    this.backToRootNavigator = false,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    // final coordinator = ref.read(coordinatorProvider);
    final bgColor = backgroundColor ?? Theme.of(context).navigationBackground;

    return Container(
      color: bgColor,
      child: SafeArea(
        child: Container(
          color: bgColor,
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Stack(
            children: [
              if (showsBackButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.chevron_left,
                          size: 42.0,
                          color: Colors.white,
                        ),
                        Text(
                          '戻る',
                          style: Theme.of(context).textTheme.appBarTitle,
                        ),
                      ],
                    ),
                    onPressed: () async {
                      Navigator.of(context, rootNavigator: backToRootNavigator)
                          .pop(backResult);
                    },
                  ),
                ),
              Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.appBarTitle,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
