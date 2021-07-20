import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather/cweathermodel.dart';
import 'package:simple_weather/fweathermodel.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';
import 'dart:convert';
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
  // static const IconData wb_sunny_rounded =
  //     IconData(0xf540, fontFamily: 'MaterialIcons');
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(),
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

    loWeather.forEach(
        (jsonInList) => jsonInList = ForecastWeatherModel.fromJson(jsonInList));

    return loWeather
        .map((jsonInList) => ForecastWeatherModel.fromJson(jsonInList))
        .toList();
  }

  Future<CardWeatherModel> cardFuture;
  Future<CardWeatherModel> cardFetch() async {
    var response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=orlando&appid=49a2adca18d67e77118367efe5497060'));

    var loCardWeather = jsonDecode(response.body);
    print(loCardWeather.runtimeType);
    return CardWeatherModel.fromJson(loCardWeather);
  }

  @override
  void initState() {
    super.initState();
    forecastFuture = forecastFetch();
    cardFuture = cardFetch();
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
                height: 250,
                child: FutureBuilder(
                    future: cardFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        print(snapshot.data);
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
            Row(
              children: [
                Text('Next 7 days',
                    style: GoogleFonts.poppins(
                      textStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                          color: Colors.black),
                    )).myPadding(8),
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
                  ).myPadding(25),
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
                ).myPadding(25),
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
                ).myPadding(25),
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
                ).myPadding(25),
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
                ).myPadding(25),
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
                        fontSize: 18.0,
                        color: Colors.white),
                  )).myPadding(10),
              Text(card.time.toReadable(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(fontSize: 15.0, color: Colors.white),
                  )).myPadding(10),
              //303.2.toFString()
              Text(card.temp.toRound(4).toString(),
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 50.0,
                        color: Colors.white),
                  )).myPadding(10),
              Text(card.condition,
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
