class ForecastWeatherModel {
  int time = 0;
  String picture = '';
  String condition = 'cloudy';

  //constructor
  ForecastWeatherModel({int time, String pictureUrl, String condition}) {
    // print('Hello');
    this.time = time;
    picture = pictureUrl;
    this.condition = condition;
  }
// *Factory keyword is used when implementing constructors that do not create new instances of the existing class.

// The constructor below does not create new instances of the existing class ForecastWeatherModel and you are just referencing it back. Instance of a subtype deals with inheritance

// *A factory constructor can return value from cache or from an instance of a sub-type. Cache meaning the object already exists and is already created

// *Factory constructor does not have access to the this keyword

//Because if you're going to use the this keyword you're probably going to use it to construct an object so you can just use the normal constructors

//* Factory constructors are like static methods whose return type is the class itself

// The return type should be the class itself

// Proper use case of factory constructor:
// Use factory constructor when creating a new instance of an existing class is too expensive
// Creating only one instance of the class
// For returning sub-class instance of the class instead of the class itself
  factory ForecastWeatherModel.fromJson(Map<String, dynamic> json) {
    return ForecastWeatherModel(
      time: json['dt'],
      pictureUrl:
          "https://openweathermap.org/img/wn/${json['weather'][0]['icon']}@2x.png",
      condition: json["weather"][0]["main"],
    );
  }
  // Map<String, dynamic> toJson() {
  //   final Map<String, dynamic> data = new Map<String, dynamic>();
  //   data['time'] = this.time;
  //   data['condition'] = this.condition;

  //   return data;
  // }
}
