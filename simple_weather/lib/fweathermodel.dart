class ForecastWeatherModel {
  int time = 0;
  String picture = '';
  String condition = 'cloudy';
  double temp = 0.0;

  ForecastWeatherModel(
      {int time, String pictureUrl, String condition, double temp}) {
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
    this.temp = temp;
  }

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      time: json['dt'] ?? 0,
      pictureUrl:
          "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      condition: json["weather"][0]["main"] ?? 0,
      temp: json['main']['temp'] ?? 0,
    );
  }
}
