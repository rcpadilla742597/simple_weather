import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../main.dart';

class HomeController extends GetxController {
  PageController pageController;
  var currentIndex = 0.obs;
  GlobalKey bottomNavigationKey = GlobalKey();
  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: 0);
  }

  var currentWeatherScreen = WeatherScreen(cityName: 'Orlando').obs;

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    pageController.dispose();
  }

  void change(int position) {
    currentIndex.value = position;
  }
}
