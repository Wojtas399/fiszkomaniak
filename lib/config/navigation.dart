import 'package:flutter/material.dart';
import '../features/home/home.dart';

class Navigation {
  static void navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }
}
