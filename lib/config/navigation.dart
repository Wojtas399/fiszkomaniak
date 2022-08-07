import 'package:flutter/material.dart';
import '../components/dialogs/dialogs.dart';
import '../config/routes.dart';
import '../config/slide_right_route_animation.dart';
import '../features/flashcard_preview/flashcard_preview_screen.dart';
import '../features/group_creator/group_creator_mode.dart';
import '../features/home/home_router.dart';
import '../config/slide_up_route_animation.dart';
import '../features/course_creator/course_creator_mode.dart';
import '../features/initial_home/initial_home.dart';
import '../features/reset_password/reset_password_screen.dart';
import '../features/session_creator/bloc/session_creator_mode.dart';
import '../features/session_preview/bloc/session_preview_mode.dart';
import '../features/home/home.dart';
import '../features/learning_process/learning_process_data.dart';

class Navigation {
  static void moveBack({Object? objectToReturn}) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pop(objectToReturn);
  }

  static void pushReplacementToInitialHome() {
    navigatorKey.currentState?.pushReplacement(
      SlideRightRouteAnimation(page: const InitialHome()),
    );
  }

  static void pushReplacementToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  static void navigateToResetPassword(BuildContext context) {
    Navigator.of(context).push(SlideUpRouteAnimation(
      page: const ResetPasswordScreen(),
    ));
  }

  static void backHome() {
    navigatorKey.currentState?.popUntil(
      ModalRoute.withName(Routes.home),
    );
  }

  static void navigateToSettings() {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(Routes.settings);
  }

  static Future<void> navigateToCourseCreator(CourseCreatorMode mode) async {
    Dialogs.hideSnackbar();
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        navigatorKey.currentState?.pushNamed(
          Routes.courseCreator,
          arguments: mode,
        );
      },
    );
  }

  static Future<void> navigateToGroupCreator(GroupCreatorMode mode) async {
    Dialogs.hideSnackbar();
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        navigatorKey.currentState?.pushNamed(
          Routes.groupCreator,
          arguments: mode,
        );
      },
    );
  }

  static void navigateToSessionCreator(SessionCreatorMode mode) async {
    Dialogs.hideSnackbar();
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        navigatorKey.currentState?.pushNamed(
          Routes.sessionCreator,
          arguments: mode,
        );
      },
    );
  }

  static void navigateToGroupSelection() {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.groupSelection,
    );
  }

  static void navigateToFlashcardsEditor(String groupId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.flashcardsEditor,
      arguments: groupId,
    );
  }

  static void navigateToCourseGroupsPreview(String courseId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.courseGroupsPreview,
      arguments: courseId,
    );
  }

  static void navigateToGroupFlashcardsPreview(String groupId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.groupFlashcardsPreview,
      arguments: groupId,
    );
  }

  static void navigateToGroupPreview(String groupId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.groupPreview,
      arguments: groupId,
    );
  }

  static void navigateToFlashcardPreview(String groupId, int flashcardIndex) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.flashcardPreview,
      arguments: FlashcardPreviewScreenArguments(
        groupId: groupId,
        flashcardIndex: flashcardIndex,
      ),
    );
  }

  static void navigateToSessionPreview(SessionPreviewMode mode) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.sessionPreview,
      arguments: mode,
    );
  }

  static void navigateToLearningProcess(LearningProcessData data) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.session,
      arguments: data,
    );
  }
}
