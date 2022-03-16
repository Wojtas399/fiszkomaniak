import 'package:fiszkomaniak/config/keys.dart';
import 'package:fiszkomaniak/config/route_animations.dart';
import 'package:flutter/material.dart';
import '../features/home/home.dart';

class Navigation {
  static void navigateToHome() {
    final currentState = Keys.navigatorKey.currentState;
    if (currentState != null) {
      currentState.pushReplacement(MaterialPageRoute(builder: (_) => Home()));
    }
  }

  static void navigateToPageWithSlideUpAnim(Widget child) {
    final currentState = Keys.navigatorKey.currentState;
    if (currentState != null) {
      currentState.push(RouteAnimations(page: child));
    }
  }
}
