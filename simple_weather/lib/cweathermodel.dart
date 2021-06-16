// a class indicates an object we create. This is my widget. It is the representation of my widget.

class CardWeatherModel {
  String city = '';
  String date = '';
  String temp = '';
  String condition = '';

// constructor - this is what's happening inside the widget

  CardWeatherModel({String city, String date, String temp, String condition}) {
    this.city = city;
    this.date = date;
    this.temp = temp;
    this.condition = condition;
  }
}
