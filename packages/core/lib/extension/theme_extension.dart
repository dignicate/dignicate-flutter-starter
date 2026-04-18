import 'package:flutter/material.dart';

extension ThemeDataExtension on ThemeData {
  Color get textRed => const Color(0xFFFF0000);
  Color get textGray => const Color(0xFF878787);
  Color get navigationBackground => const Color(0xFFFFFFFF);
}

extension TextThemeExtensions on TextTheme {
  TextStyle get appBarTitle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF333333),
      );
}
