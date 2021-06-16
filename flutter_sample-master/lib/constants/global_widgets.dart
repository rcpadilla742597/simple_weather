import 'package:flutter/material.dart';

//Widgets
SizedBox spacer({double width, double height}) {
  return SizedBox(
    height: height != null ? height : 0,
    width: width != null ? width : 0,
  );
}
