import 'package:flutter/material.dart';
import 'package:core/extension/theme_extension.dart';

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
    final bgColor = backgroundColor ?? Theme.of(context).navigationBackground;
    final textStyle = Theme.of(context).textTheme.appBarTitle;

    return Material(
      color: bgColor,
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: preferredSize.height,
          child: Stack(
            children: [
              // タイトルを中央に配置
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 80.0),
                  child: Text(
                    title,
                    style: textStyle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ),
              // 戻るボタンを左端に配置
              if (showsBackButton)
                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () {
                      Navigator.of(context, rootNavigator: backToRootNavigator)
                          .pop(backResult);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chevron_left,
                          size: 42.0,
                          color: textStyle.color,
                        ),
                        Text(
                          '戻る',
                          style: textStyle,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
