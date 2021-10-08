import 'package:flutter/material.dart';
import 'colors.dart';

@immutable
class CustomTheme {
  static const colors = MyColors();

  const CustomTheme._();

  static ThemeData define() {
    return ThemeData(
      primaryColor: Color(0xFF292929),
      focusColor: Color(0xFFFFFFFF),
    );
  }
}
