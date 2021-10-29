import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:simple_weather/cweathermodel.dart';
import 'package:simple_weather/custom_theme.dart';
import 'package:simple_weather/dweathermodel.dart';
import 'package:simple_weather/fweathermodel.dart';
import 'package:http/http.dart' as http;
import 'package:device_preview/device_preview.dart';
import 'dart:convert';
import 'controllers/home_controller.dart';
import 'extenstions.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() => runApp(DevicePreview(
    enabled: true,
    defaultDevice: Devices.ios.iPhone11ProMax,
    style: DevicePreviewStyle(
        background: BoxDecoration(color: Colors.blue),
        toolBar: DevicePreviewToolBarStyle.dark()),
    builder: (context) {
      return MyApp();
    }));
// void main() => runApp(MyApp());
// this is what you need when you are ready go to production

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       defaultTransition: Transition.fadeIn,
//       transitionDuration: Duration(milliseconds: 400),
//       debugShowCheckedModeBanner: false,
//       home: Listener(
//           onPointerDown: (_) {
//             FocusScopeNode currentFocus = FocusScope.of(context);
//             if (!currentFocus.hasPrimaryFocus &&
//                 currentFocus.focusedChild != null) {
//               currentFocus.focusedChild.unfocus();
//             }
//           },
//           child: FutureBuilder(
//               future: Hive.openBox('anime'),
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) {
//                   return Center(
//                     child: CircularProgressIndicator(),
//                   );
//                 } else {
//                   return HomeScreen();
//                 }
//               })),
//     );
//   }
// }

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home:
          HomeScreen(), //wrap this homescreen in this listener wiget, copy the code
    );
  }
}

// <----------------------------- BEGINNING OF HOMESCREEN ----------------------------->
// Houses pageview, animatedswitcher, search, scaffold, appbar, camera, settings, fancybottomnavigation

class HomeScreen extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Obx(
        () => AnimatedSwitcher(
            duration: Duration(seconds: 1),
            child: controller.currentWeatherScreen.value),
      ),
      Camera(),
      Settings()
    ];
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        children: [
          Obx(
            () => AnimatedSwitcher(
                duration: Duration(seconds: 1),
                child: controller.currentWeatherScreen.value),
          ),
          Camera(),
          Settings()
        ],
        controller: controller.pageController,
      ),
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: 'Home'),
          TabData(iconData: Icons.camera, title: 'Camera'),
          TabData(iconData: Icons.settings, title: 'Settings'),
        ],
        onTabChangedListener: (position) {
          controller.currentIndex.value = position;
          controller.pageController.jumpToPage(position);
          controller.change(position);
        },
        initialSelection: controller.currentIndex.value,
        key: controller.bottomNavigationKey,
      ),
      drawer: Drawer(child: Container(color: CustomTheme.colors.customRed)),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Weather', style: TextStyle(color: Colors.black)),
      ),
    );
  }
}

// <----------------------------- END OF HOMESCREEN ----------------------------->

// <----------------------------- BEGINNING OF CAMERA ----------------------------->

class Camera extends StatelessWidget {
  const Camera({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          // Navigate back to first route when tapped.
        },
        child: Text('Test 1'),
      ),
    );
  }
}
// <----------------------------- END OF CAMERA ----------------------------->

// <----------------------------- BEGINNING OF SETTINGS ----------------------------->

class Settings extends StatefulWidget {
  Settings({Key key}) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>
    with AutomaticKeepAliveClientMixin {
  @override
  // TODO: Implement wantKeepAlive to store theme. Use shared preferences
  bool get wantKeepAlive => true;

  bool valNotify1 = false;

  bool valNotify2 = false;

  bool valNotify3 = false;

  onChangeFunction1(bool newValue1) {
    setState(() {
      valNotify1 = newValue1;
      Get.changeTheme(Get.isDarkMode ? ThemeData.light() : ThemeData.dark());
    });
  }

  onChangeFunction2(bool newValue2) {
    setState(() {
      valNotify2 = newValue2;
    });
  }

  onChangeFunction3(bool newValue3) {
    setState(() {
      valNotify3 = newValue3;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            //Account
            SizedBox(height: 40),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.blue,
                ),
                SizedBox(width: 10),
                Text("Account",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildAccountOption(context, "Change Password"),
            buildAccountOption(context, "Content Settings"),
            buildAccountOption(context, "Social"),
            buildAccountOption(context, "Language"),
            buildAccountOption(context, "Privacy and Security"),

            //Notifications
            SizedBox(height: 40),
            Row(
              children: [
                Icon(Icons.volume_up_outlined, color: Colors.blue),
                SizedBox(width: 10),
                Text("Notifications",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold))
              ],
            ),
            Divider(height: 20, thickness: 1),
            SizedBox(height: 10),
            buildNotificationOption(
                "Theme Dark", valNotify1, onChangeFunction1),
            buildNotificationOption(
                "Account Active", valNotify2, onChangeFunction2),
            buildNotificationOption(
                "Opportunity", valNotify3, onChangeFunction3),
            SizedBox(height: 50),
            Center(
                child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20))),
              onPressed: () {},
              child: Text("SIGN OUT",
                  style: TextStyle(
                    fontSize: 16,
                    letterSpacing: 2.2,
                  )),
            ))
          ],
        ));
  }
}

Padding buildNotificationOption(
    String title, bool value, Function onChangeMethod) {
  return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600])),
        Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              activeColor: Colors.blue,
              trackColor: Colors.grey,
              value: value,
              onChanged: (bool newValue) {
                onChangeMethod(newValue);
              },
            ))
      ]));
}

// onTap shows Option 1 and 2 with
GestureDetector buildAccountOption(BuildContext context, String title) {
  return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text("Option 1"), Text("Option 2")],
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Close"))
                ],
              );
            });
      },
      child: Container(
        color: Colors.transparent,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600])),
                Icon(Icons.arrow_forward_ios, color: Colors.grey)
              ],
            )),
      ));
}
// <----------------------------- END OF SETTINGS ----------------------------->

// <----------------------------- BEGINNING OF WEATHERSCREEN  ----------------------------->

class WeatherScreen extends StatefulWidget {
  final String cityName;
  const WeatherScreen({
    Key key,
    this.cityName,
  }) : super(key: key);
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  HomeController controller = Get.find();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _controller = new TextEditingController();

// <!------ BEGINNING OF FWEATHERMODEL CONSTRUCTOR (Today) ------!>

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
// <!------ END OF FWEATHERMODEL CONSTRUCTOR (Today) ------!>

// <!------ BEGINNING OF CWEATHERMODEL CONSTRUCTOR (Card) ------!>

  Future<CardWeatherModel> cardFuture;
  Future<CardWeatherModel> cardFetch(String query) async {
    // print(name);
    try {
      var response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=${query}&appid=49a2adca18d67e77118367efe5497060'));

      var loCardWeather = jsonDecode(response.body);

      return CardWeatherModel.fromJson(loCardWeather);
    } catch (e) {
      print('caught error');
      Get.back();
      Get.defaultDialog(title: "Error", content: Text("You are not logged in"));
      // return CardWeatherModel(
      //     condition: 'error',
      //     temp: 0.0,
      //     location: 'City not found',
      //     time: 0,
      //     pictureUrl:
      //         'https://p.kindpng.com/picc/s/119-1190723_warning-warning-vector-png-warning-icon-transparent-png.png');
    }
  }

  // <!------ END OF CWEATHERMODEL CONSTRUCTOR (Card) ------!>

// <!------ BEGINNING OF DWEATHERMODEL CONSTRUCTOR (Next 5 Days) ------!>

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
    // for in loop
    List loDaysWeather = ["Mercury", "Venus", "Earth", "Mars"];

    for (String response in loDaysWeather) {
      // print(response);
    }
  }

  // <!------ END OF DWEATHERMODEL CONSTRUCTOR (Next 5 Days) ------!>

  @override
  Widget build(BuildContext context) {
    HomeController controller = Get.put(HomeController());
    return Material(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Search Bar
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
                            onPressed: () async {
                              print(_controller.text);
                              print(_formKey.currentState.validate());
                              if (_formKey.currentState.validate()) {
                                print("I'm here");
                                try {
                                  var response = await http.get(Uri.parse(
                                      'https://api.openweathermap.org/data/2.5/weather?q=${_controller.text}&appid=49a2adca18d67e77118367efe5497060'));

                                  var loCardWeather = jsonDecode(response.body);
                                  setState(() {
                                    controller.currentWeatherScreen.value =
                                        WeatherScreen(
                                            cityName: _controller.text,
                                            key: Key(_controller.text));
                                    print(controller
                                        .currentWeatherScreen.value.cityName);
                                  });
                                } catch (e) {
                                  Get.defaultDialog(
                                      title: "Error",
                                      content: Text("You are not logged in"));
                                }
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
            // Today Forecast
            Text('Today',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: CustomTheme.colors.lightBlue,
                  ),
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
                              margin: EdgeInsets.symmetric(horizontal: 10),
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
            Text('Next 5 days',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: CustomTheme.colors.lightBlue,
                  ),
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
                            headingRowHeight: 0.0, // This hides the tabs
                            horizontalMargin: 0.0, // Adjusts the lines
                            columnSpacing: 60,
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
                                  Center(
                                    child: Image(
                                      // width: 50,
                                      // height: 50,
                                      image: NetworkImage(
                                        weather.picture,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(temp.toFString()),
                                  ],
                                )),
                              ]);
                            }).toList()),
                      ),
                    );
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

  // Rendering CardWeatherModel
  Widget renderCard(CardWeatherModel card) {
    // print(card.temp);
    // print(card.temp.runtimeType);
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: card.temp >= 294.261 ? cList1 : cList2,
        ),
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      width: 375,
      height: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(card.location ?? '',
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
              Text(card.condition,
                  style: GoogleFonts.poppins(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15.0,
                        color: Colors.white),
                  )).myPadding(10),
            ],
          ),
          Container(
            margin: EdgeInsets.only(right: 50.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SvgPicture.network(
                  card.picture,
                  width: 80,
                  height: 80,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// <----------------------------- END OF WEATHERSCREEN  ----------------------------->