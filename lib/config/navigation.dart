import 'package:fiszkomaniak/features/home/home_router.dart';
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

  static void navigateToSettings() {
    HomeRouter.navigatorKey.currentState?.pushNamed(HomeRouter.settings);
  }

  static void navigateToCourseCreator(CourseCreatorMode mode) async {
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        HomeRouter.navigatorKey.currentState?.pushNamed(
          HomeRouter.courseCreator,
          arguments: mode,
        );
      },
    );
  }
}
