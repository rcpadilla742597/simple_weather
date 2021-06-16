import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather/cweathermodel.dart';
import 'package:simple_weather/fweathermodel.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';
import 'dart:convert';

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
  static const IconData wb_sunny_rounded =
      IconData(0xf540, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<ForecastWeatherModel>> forecastFuture;
  Future<List<ForecastWeatherModel>> forecastFetch() async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?id=524901&appid=49a2adca18d67e77118367efe5497060'));

    List loWeather = jsonDecode(response.body)["list"];

    // loWeather.forEach((element) {
    //   print(element);
    // });
    print(loWeather);

    loWeather.forEach(
        (jsonInList) => jsonInList = ForecastWeatherModel.fromJson(jsonInList));
    print(loWeather);
    return loWeather
        .map((jsonInList) => ForecastWeatherModel.fromJson(jsonInList))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    forecastFuture = forecastFetch();
  }

  ForecastWeatherModel myModel = ForecastWeatherModel(
      condition: "test1", pictureUrl: "test2", time: "test3");

  List topInfo = [
    ForecastWeatherModel(condition: "Sunny", pictureUrl: "dog", time: "Now"),
    ForecastWeatherModel(condition: "Sunny", pictureUrl: "dog", time: "02:00"),
    ForecastWeatherModel(condition: "Cloudy", pictureUrl: "dog", time: "03:00"),
    ForecastWeatherModel(condition: "Rain", pictureUrl: "dog", time: "04:00"),
    ForecastWeatherModel(condition: "Rain", pictureUrl: "dog", time: "05:00")
  ];

  CardWeatherModel cardModel = CardWeatherModel(
      city: 'Orlando',
      date: 'June 01 2021',
      temp: 'Warm',
      condition: 'Partly Cloudy');

  List cardInfo = List.filled(
      5,
      CardWeatherModel(
          city: 'Tulungagung',
          date: 'Saturday, 01 May 2021',
          temp: '24°',
          condition: 'Sunny'));

  @override
  Widget build(BuildContext context) {
    // print(cardModel.city); //Prints Orlando
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: List.generate(
                  cardInfo.length,
                  (index) => Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        color: Colors.blue),
                    width: 400,
                    height: 250,
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('${cardInfo[index].city}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18.0,
                                      color: Colors.white),
                                )),
                            Text('${cardInfo[index].date}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontSize: 15.0, color: Colors.white),
                                )),
                            Text('${cardInfo[index].temp}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 50.0,
                                      color: Colors.white),
                                )),
                            Text('${cardInfo[index].condition}',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.0,
                                      color: Colors.white),
                                )),
                          ],
                        ),
                        Container(
                          child: Icon(Icons.wb_sunny_rounded,
                              color: Colors.yellow, size: 100),
                          padding: const EdgeInsets.all(70),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Text('Today',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18.0,
                      color: Colors.black),
                )),
            FutureBuilder(
                future: forecastFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                        width: 50,
                        height: 50,
                        color: Colors.red,
                        child: Text("snapshot.data[0].condition"));
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            Row(
              children: [
                Text('Next 7 days',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          color: Colors.black),
                    )),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Text(
                    'Sunday',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ),
                ),
                Flexible(
                    flex: 1,
                    child: Icon(Icons.wb_sunny_rounded,
                        color: Colors.yellow, size: 25)),
                Flexible(flex: 1, child: Text('24°/25°'))
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Monday',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                Icon(Icons.wb_sunny_rounded, color: Colors.yellow, size: 25),
                Text('19°/21°')
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tuesday',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                Icon(Icons.wb_sunny_rounded, color: Colors.yellow, size: 25),
                Text('24°/25°')
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Wednesday',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                Icon(Icons.wb_sunny_rounded, color: Colors.yellow, size: 25),
                Text('28°/29°')
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thursday',
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                  ),
                ),
                Icon(Icons.wb_sunny_rounded, color: Colors.yellow, size: 25),
                Text('24°/25°',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(fontSize: 14.0, color: Colors.black),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
