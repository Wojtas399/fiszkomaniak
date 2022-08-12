import 'package:flutter/material.dart';
import '../config/routes.dart';
import '../config/slide_right_route_animation.dart';
import '../features/flashcard_preview/flashcard_preview_screen.dart';
import '../features/group_creator/bloc/group_creator_mode.dart';
import '../config/slide_up_route_animation.dart';
import '../features/course_creator/bloc/course_creator_mode.dart';
import '../features/initial_home/initial_home.dart';
import '../features/reset_password/reset_password_screen.dart';
import '../features/session_creator/bloc/session_creator_mode.dart';
import '../features/session_preview/bloc/session_preview_mode.dart';
import '../features/home/home.dart';
import '../features/learning_process/learning_process_arguments.dart';
import '../providers/dialogs_provider.dart';
import '../providers/global_navigator_key_provider.dart';

class Navigation {
  static void moveBack({Object? objectToReturn}) {
    DialogsProvider.hideSnackbar();
    _getNavigatorState()?.pop(objectToReturn);
  }

  static void pushReplacementToInitialHome() {
    _getNavigatorState()?.pushReplacement(
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
    _getNavigatorState()?.popUntil(
      ModalRoute.withName(Routes.home),
    );
  }

  static void navigateToSettings() {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(Routes.settings);
  }

  static Future<void> navigateToCourseCreator(CourseCreatorMode mode) async {
    _hideSnackbar();
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        _getNavigatorState()?.pushNamed(
          Routes.courseCreator,
          arguments: mode,
        );
      },
    );
  }

  static Future<void> navigateToGroupCreator(GroupCreatorMode mode) async {
    _hideSnackbar();
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        _getNavigatorState()?.pushNamed(
          Routes.groupCreator,
          arguments: mode,
        );
      },
    );
  }

  static void navigateToSessionCreator(SessionCreatorMode mode) async {
    _hideSnackbar();
    await Future.delayed(
      const Duration(milliseconds: 1),
      () {
        _getNavigatorState()?.pushNamed(
          Routes.sessionCreator,
          arguments: mode,
        );
      },
    );
  }

  static void navigateToGroupSelection() {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.groupSelection,
    );
  }

  static void navigateToFlashcardsEditor(String groupId) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.flashcardsEditor,
      arguments: groupId,
    );
  }

  static void navigateToCourseGroupsPreview(String courseId) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.courseGroupsPreview,
      arguments: courseId,
    );
  }

  static void navigateToGroupFlashcardsPreview(String groupId) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.groupFlashcardsPreview,
      arguments: groupId,
    );
  }

  static void navigateToGroupPreview(String groupId) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.groupPreview,
      arguments: groupId,
    );
  }

  static void navigateToFlashcardPreview(String groupId, int flashcardIndex) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.flashcardPreview,
      arguments: FlashcardPreviewScreenArguments(
        groupId: groupId,
        flashcardIndex: flashcardIndex,
      ),
    );
  }

  static void navigateToSessionPreview(SessionPreviewMode mode) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.sessionPreview,
      arguments: mode,
    );
  }

  static void navigateToLearningProcess(LearningProcessArguments arguments) {
    _hideSnackbar();
    _getNavigatorState()?.pushNamed(
      Routes.session,
      arguments: arguments,
    );
  }

  static void _hideSnackbar() {
    DialogsProvider.hideSnackbar();
  }

  static NavigatorState? _getNavigatorState() {
    return GlobalNavigatorKeyProvider.getState();
  }
}
