import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_page.dart';
import 'package:flutter/material.dart';
import '../features/home/home.dart';

class Navigation {
  static void pushReplacementToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  static void navigateToResetPassword(BuildContext context) {
    Navigator.of(context).push(SlideUpRouteAnimation(
      page: const ResetPasswordPage(),
    ));
  }

  static void backHome() {
    HomeRouter.navigatorKey.currentState?.popUntil(
      ModalRoute.withName(HomeRouter.home),
    );
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

  static Future<void> navigateToGroupCreator(GroupCreatorMode mode) async {
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        HomeRouter.navigatorKey.currentState?.pushNamed(
          HomeRouter.groupCreator,
          arguments: mode,
        );
      },
    );
  }

  static void navigateToSessionCreator() async {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.sessionCreator,
    );
  }

  static void navigateToGroupSelection() {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupSelection,
    );
  }

  static void navigateToFlashcardsEditor(String groupId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.flashcardsEditor,
      arguments: groupId,
    );
  }

  static void navigateToCourseGroupsPreview(String courseId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.courseGroupsPreview,
      arguments: courseId,
    );
  }

  static void navigateToGroupFlashcardsPreview(String groupId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupFlashcardsPreview,
      arguments: groupId,
    );
  }

  static void navigateToGroupPreview(String groupId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupPreview,
      arguments: groupId,
    );
  }

  static void navigateToFlashcardPreview(String flashcardId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.flashcardPreview,
      arguments: flashcardId,
    );
  }
}
