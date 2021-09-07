class ForecastWeatherModel {
  int time = 0;
  String picture = '';
  String condition = 'cloudy';

  ForecastWeatherModel({int time, String pictureUrl, String condition}) {
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
  }

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      time: json['dt'] ?? 0,
      pictureUrl:
          "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      condition: json["weather"][0]["main"] ?? 0,
    );
  }
}
