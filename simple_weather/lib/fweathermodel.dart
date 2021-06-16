class ForecastWeatherModel {
  String time = '';
  String picture = '';
  String condition = 'cloudy';

  //constructor
  ForecastWeatherModel({String time, String pictureUrl, String condition}) {
    // print('Hello');
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
  }

  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      time: json["dt"],
      pictureUrl:
          "http://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      condition: json["weather"][0]["main"],
    );
  }
}
