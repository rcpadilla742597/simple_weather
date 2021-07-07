// ignore: implementation_imports
import 'package:flutter/src/widgets/basic.dart';

class CardWeatherModel {
  String location = '';

  double temp = 0.0;
  String picture = '';
  String condition = '';
  int time = 0;

  CardWeatherModel({
    String location,
    double temp,
    String pictureUrl,
    String condition,
    int time,
  }) {
    this.location = location;

    this.temp = temp;
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
  }

  factory CardWeatherModel.fromJson(Map<String, dynamic> json) {
    print(json["name"]);
    return CardWeatherModel(
      time: json['dt'],
      location: json['name'],
      temp: json['main']['temp'],
      pictureUrl:
          "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      condition: json["weather"][0]["description"],
    );
  }
}
