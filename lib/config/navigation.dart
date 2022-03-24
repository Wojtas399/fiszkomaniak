import 'package:fiszkomaniak/config/app_router.dart';
import 'package:fiszkomaniak/config/keys.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:flutter/material.dart';
import '../features/home/home.dart';

class Navigation {
  static void pushReplacementToHome() {
    final currentState = Keys.navigatorKey.currentState;
    currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  static void navigateToPageWithSlideUpAnim(Widget child) {
    final currentState = Keys.navigatorKey.currentState;
    currentState?.push(SlideUpRouteAnimation(page: child));
  }

  static void navigateToSettings(BuildContext context) {
    Navigator.of(context).pushNamed(AppRouter.settings);
  }

  static void navigateToCourseCreator(
    BuildContext context,
    CourseCreatorMode mode,
  ) {
    Navigator.of(context).pushNamed(
      AppRouter.courseCreator,
      arguments: mode,
    );
  }
}
