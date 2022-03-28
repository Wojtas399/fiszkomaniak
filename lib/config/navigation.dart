import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_arguments.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_page.dart';
import 'package:fiszkomaniak/main.dart';
import 'package:flutter/material.dart';
import '../features/home/home.dart';

class Navigation {
  static void pushReplacementToHome() {
    MyApp.navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  static void navigateToResetPassword() {
    MyApp.navigatorKey.currentState?.push(SlideUpRouteAnimation(
      page: const ResetPasswordPage(),
    ));
  }

  static void navigateToSettings() {
    HomeRouter.navigatorKey.currentState?.pushNamed(HomeRouter.settings);
  }

  static Future<void> navigateToCourseCreator(CourseCreatorMode mode) async {
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

  static void navigateToGroupPreview(String groupId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupPreview,
      arguments: groupId,
    );
  }
}
