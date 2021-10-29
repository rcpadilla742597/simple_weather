// ignore: implementation_imports

class CardWeatherModel {
  String location = '';
  double temp = 0.0;
  String picture = '';
  String condition = '';
  int time = 0;
  String message = '';

  CardWeatherModel({
    String location,
    double temp,
    String pictureUrl,
    String condition,
    int time,
    String message,
  }) {
    this.location = location;

    this.temp = temp;
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
    this.message = message;
  }

  factory CardWeatherModel.fromJson(Map<String, dynamic> json) {
    // print(json["name"]);
    //add error checking
    return CardWeatherModel(
      time: json['dt'] ?? 0,
      location: json['name'] ?? '0',
      temp: json['main']['temp'] ?? 0,
      pictureUrl:
          "https://raw.githubusercontent.com/rcpadilla742597/open-weather-icons/main/${json['weather'][0]['icon']}.svg",
      condition: json["weather"][0]["description"],
      message: "${json['message']}",
    );
  }
}
