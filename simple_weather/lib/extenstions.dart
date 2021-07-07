// ignore: unused_import
import 'package:intl/intl.dart';

extension WeatherExtensions on double {
  String toFString() {
    var convert = (this - 273) * (9 / 5) + 32;
    convert = convert.roundToDouble();
    return '$convert°';
  }

  double toF() {
    var convert = (this - 273) * (9 / 5) + 32;
    return convert;
  }
}

extension TimeExtensions on int {
  String toReadable() {
    var date = DateTime.fromMillisecondsSinceEpoch((this * 1000).round());
    var formattedDate = DateFormat.yMMMd().format(date); // Apr 8, 2020
    return '$formattedDate';
  }
}
