import 'package:flutter/material.dart';

TextStyle titleStyle =
    TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold);

TextStyle whiteBold({double fontSize, Color color}) => TextStyle(
    color: color != null ? color : Colors.white,
    fontSize: fontSize,
    fontWeight: FontWeight.bold);

TextStyle whiteRegular({double fontSize, Color color}) => TextStyle(
      color: color != null ? color : Colors.white,
      fontSize: fontSize,
    );
