import 'package:flutter/material.dart';
import 'package:gitpodflutter/screens/home_page.dart';
import 'package:device_preview/device_preview.dart';

//main method is the entry point into the app runApp method gets the app up and running
void main() => runApp(DevicePreview(
    enabled: true,
    defaultDevice: Devices.ios.iPhone11ProMax,
    style: DevicePreviewStyle(
        background: BoxDecoration(color: Colors.black),
        toolBar: DevicePreviewToolBarStyle.dark()),
    builder: (context) {
      return MyApp();
    }));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //MaterialApp is the foundation for all the widgets below it essentially starts the context "river" MaterialApp uses Google's Material Design princples and widgets
    //There is CupertinoApp which uses Cupertino style but it is rarely used
    return MaterialApp(
      //gets rid of debug banner
      debugShowCheckedModeBanner: false,
      title: 'Flutter Example',
      //First rendered page
      home: MyHomePage(),
    );
  }
}
