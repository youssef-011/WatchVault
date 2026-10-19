import 'package:flutter/material.dart';

abstract final class AppTextStyles {
  static TextTheme from(ColorScheme colorScheme) =>
      ThemeData(colorScheme: colorScheme).textTheme;
}
