import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/features/home/home_view.dart';
import 'package:fiszkomaniak/features/settings/settings_page.dart';
import 'package:flutter/material.dart';

class AppRouter {
  static const String home = '/';

  static const String settings = '/settings';

  static const String courseCreator = '/course_creator';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomeView());
      case settings:
        return SlideUpRouteAnimation(page: const SettingsPage());
      case courseCreator:
        return SlideUpRouteAnimation(page: const CourseCreator());
      default:
        return MaterialPageRoute(builder: (_) => const Home());
    }
  }
}
