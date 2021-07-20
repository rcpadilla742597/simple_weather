// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Kelvein to Fahrenheit
extension WeatherExtensions on double {
  String toFString() {
    var convert = (this - 273) * (9 / 5) + 32;
    // convert = convert.roundToDouble();
    return '$convert°';
  }

  double toF() {
    var convert = (this - 273) * (9 / 5) + 32;
    return convert;
  }
}

// Double with rounding
extension RoundDouble on double {
  double toRound(int round) {
    var round2 = double.parse((this).toStringAsFixed(round));
    return round2;
  }
}

// Widget myPadding(double padding) => Padding(
//         padding: EdgeInsets.all(padding),
//         child: this,
//       );

// Attaching hello to string
extension Hello on String {
  String toHello() {
    var attach = this;
    return '$attach Hello';
  }
}

// Timestamp to Date
extension TimeExtensions on int {
  String toReadable() {
    var date = DateTime.fromMillisecondsSinceEpoch((this * 1000).round());
    var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020
    return '$formattedDate';
  }
}

// Padding
extension PaddingExtensions on Widget {
  Widget myPadding(double padding) => Padding(
        padding: EdgeInsets.all(padding),
        child: this,
      );
}
