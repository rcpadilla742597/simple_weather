import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather/cweathermodel.dart';
import 'package:simple_weather/dweathermodel.dart';
import 'package:simple_weather/fweathermodel.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';
import 'dart:convert';
import 'constants.dart';
import 'extenstions.dart';

void main() => runApp(DevicePreview(
    enabled: true,
    defaultDevice: Devices.ios.iPhone11ProMax,
    style: DevicePreviewStyle(
        background: BoxDecoration(color: Colors.blue),
        toolBar: DevicePreviewToolBarStyle.dark()),
    builder: (context) {
      return MyApp();
    }));

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(
        cityName: 'Tampa',
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final String cityName;
  const HomeScreen({
    Key key,
    this.cityName,
  }) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();
  // Today
  Future<List<ForecastWeatherModel>> forecastFuture;
  Future<List<ForecastWeatherModel>> forecastFetch(String query) async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${query}&appid=49a2adca18d67e77118367efe5497060'));

    List loWeather = jsonDecode(response.body)["list"];

    loWeather.forEach(
        (jsonInList) => jsonInList = ForecastWeatherModel.fromJson(jsonInList));

    return loWeather
        .map((jsonInList) => ForecastWeatherModel.fromJson(jsonInList))
        .toList();
  }

// Card
  Future<CardWeatherModel> cardFuture;
  Future<CardWeatherModel> cardFetch(String query) async {
    // print(name);
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=${query}&appid=49a2adca18d67e77118367efe5497060'));

    var loCardWeather = jsonDecode(response.body);

    return CardWeatherModel.fromJson(loCardWeather);
  }

// Next 5 days
  Future<List<DaysWeatherModel>> daysFuture;
  Future<List<DaysWeatherModel>> daysFetch(String query) async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=${query}&appid=fe514ac7e7ef730c4b1da547d4a2e9ea'));

    List loDaysWeather = jsonDecode(response.body)["list"];

    List shortList = [];
    for (int i = 0; i < loDaysWeather.length; i++) {
      if (i % 8 == 0) {
        shortList.add(loDaysWeather[i]);
      }
    }

    // loDaysWeather.forEach(
    //     (jsonInList) => jsonInList = DaysWeatherModel.fromJson(jsonInList));
    return shortList
        .map((jsonInList) => DaysWeatherModel.fromJson(jsonInList))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    forecastFuture = forecastFetch(widget.cityName);
    cardFuture = cardFetch(widget.cityName);
    daysFuture = daysFetch(widget.cityName);

//Finding even numbers between 8 to 56
    for (int i = 1; i <= 56; i++) {
      if (i % 8 == 0) {
        // print(i);
      }
    }

    //for in loop

    List loDaysWeather = ["Mercury", "Venus", "Earth", "Mars"];

    for (String response in loDaysWeather) {
      // print(response);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Drawer(
          child: Container(
        color: Colors.blue,
      )),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Weather', style: TextStyle(color: Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextFormField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                        ),
                        validator: (String value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              print(_controller.text);
                              print(_formKey.currentState.validate());
                              if (_formKey.currentState.validate()) {
                                print("I'm here");

                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HomeScreen(
                                    cityName: _controller.text,
                                  ),
                                ));
                              }
                            },
                            child: const Text('Submit'),
                          ))
                    ])),
            Container(
                height: 250,
                child: FutureBuilder(
                    future: cardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // print(snapshot.data);
                        return renderCard(snapshot.data);
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    })).myPadding(17),
            Text('Today',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: Colors.black),
                )).myPadding(8),
            FutureBuilder(
                future: forecastFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      height: 100,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Container(
                              margin: EdgeInsets.symmetric(horizontal: 20),
                              width: 50,
                              height: 50,
                              child: Column(
                                children: [
                                  Text(DateTime.fromMillisecondsSinceEpoch(
                                              snapshot.data[index].time * 1000)
                                          .hour
                                          .toString() +
                                      ":00"),
                                  Image(
                                    image: NetworkImage(
                                        snapshot.data[index].picture),
                                  ),
                                  Text(snapshot.data[index].condition),
                                ],
                              ));
                        },
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),

            //Next 5 days
            Text('Next 5 days',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: Colors.black),
                )).myPadding(8),
            FutureBuilder<List<DaysWeatherModel>>(
              future: daysFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    return Center(
                      child: Container(
                        child: DataTable(
                            headingRowHeight: 0.0,
                            columns: const <DataColumn>[
                              DataColumn(label: Text('Day of week')),
                              DataColumn(label: Text('Condition')),
                              DataColumn(label: Text('Temperature')),
                            ],
                            rows: snapshot.data.map((weather) {
                              int day = weather.time;
                              double temp = weather.temp;
                              return DataRow(cells: <DataCell>[
                                DataCell(Text(day.dayOfWeek())),
                                DataCell(
                                  Image(
                                    width: 50,
                                    height: 50,
                                    image: NetworkImage(weather.picture),
                                  ),
                                ),
                                DataCell(Text(temp.toFString())),
                              ]);
                            }).toList()),
                      ),
                    );

                    // return Container(
                    //   height: 300,
                    //   child: ListView.builder(
                    //     scrollDirection: Axis.vertical,
                    //     shrinkWrap: true,
                    //     itemCount: snapshot.data.length,
                    //     itemBuilder: (context, index) {
                    //       int day = snapshot.data[index].time;
                    //       double temp = snapshot.data[index].temp;
                    //       // print(4.runtimeType);
                    //       return Container(
                    //           margin: EdgeInsets.symmetric(horizontal: 20),
                    //           child: Row(
                    //             crossAxisAlignment: CrossAxisAlignment.start,
                    //             mainAxisAlignment:
                    //                 MainAxisAlignment.spaceBetween,
                    //             children: [
                    //               Text(day.dayOfWeek()),
                    //               Image(
                    //                 width: 50,
                    //                 height: 50,
                    //                 image: NetworkImage(
                    //                     snapshot.data[index].picture),
                    //               ),
                    //               Text(temp.toFString()),
                    //             ],
                    //           ));
                    //     },
                    //   ),
                    // );
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Widget renderCard(CardWeatherModel card) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(15)),
          color: Colors.blue),
      width: 375,
      height: 250,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(card.location.toHello(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20.0,
                        color: Colors.white),
                  )).myPadding(10),
              Text(card.time.toReadable(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  )).myPadding(10),
              //303.2.toFString()
              Text(card.temp.toFString(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 60.0,
                        color: Colors.white),
                  )).myPadding(10),
              Text(card.message,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                        color: Colors.white),
                  )).myPadding(10),
            ],
          ),
        ],
      ),
    );
  }
}
