import 'package:fiszkomaniak/config/route_animations.dart';
import 'package:flutter/material.dart';
import '../features/home/home.dart';

class Navigation {
  static void navigateToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  static Future<dynamic> navigateToPage(
    BuildContext context,
    Widget child,
  ) async {
    return await Navigator.of(context).push(RouteAnimations(page: child));
  }
}
