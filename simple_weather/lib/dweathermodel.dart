class DaysWeatherModel {
  String picture = '';
  int time = 0;
  double temp = 0.0;

  DaysWeatherModel({String pictureUrl, int time, double temp}) {
    picture = pictureUrl;
    this.time = time;
    this.temp = temp;
  }

  factory DaysWeatherModel.fromJson(Map<String, dynamic> json) {
    return DaysWeatherModel(
        pictureUrl:
            "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
        time: json['dt'] ?? 0,
        temp: json['main']['temp'] ?? 0);
  }
}
