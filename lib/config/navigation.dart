import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/routes.dart';
import 'package:fiszkomaniak/config/slide_right_route_animation.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/flashcard_preview_screen.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/initial_home/initial_home.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_page.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/home/home.dart';
import '../features/learning_process/learning_process_data.dart';

class Navigation {
  void moveBack({Object? objectToReturn}) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pop(objectToReturn);
  }

  void pushReplacementToInitialHome() {
    navigatorKey.currentState?.pushReplacement(
      SlideRightRouteAnimation(page: const InitialHome()),
    );
  }

  void pushReplacementToHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Home()),
    );
  }

  void navigateToResetPassword(BuildContext context) {
    Navigator.of(context).push(SlideUpRouteAnimation(
      page: Provider.value(
        value: context.read<AuthBloc>(),
        child: const ResetPasswordPage(),
      ),
    ));
  }

  void backHome() {
    navigatorKey.currentState?.popUntil(
      ModalRoute.withName(Routes.home),
    );
  }

  void navigateToSettings() {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(Routes.settings);
  }

  Future<void> navigateToCourseCreator(CourseCreatorMode mode) async {
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

  Future<void> navigateToGroupCreator(GroupCreatorMode mode) async {
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

  void navigateToSessionCreator(SessionCreatorMode mode) async {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.sessionCreator,
      arguments: mode,
    );
  }

  void navigateToGroupSelection() {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.groupSelection,
    );
  }

  void navigateToFlashcardsEditor(String groupId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.flashcardsEditor,
      arguments: groupId,
    );
  }

  void navigateToCourseGroupsPreview(String courseId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.courseGroupsPreview,
      arguments: courseId,
    );
  }

  void navigateToGroupFlashcardsPreview(String groupId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.groupFlashcardsPreview,
      arguments: groupId,
    );
  }

  void navigateToGroupPreview(String groupId) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.groupPreview,
      arguments: groupId,
    );
  }

  void navigateToFlashcardPreview(String groupId, int flashcardIndex) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.flashcardPreview,
      arguments: FlashcardPreviewScreenArguments(
        groupId: groupId,
        flashcardIndex: flashcardIndex,
      ),
    );
  }

  void navigateToSessionPreview(SessionPreviewMode mode) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.sessionPreview,
      arguments: mode,
    );
  }

  void navigateToLearningProcess(LearningProcessData data) {
    Dialogs.hideSnackbar();
    navigatorKey.currentState?.pushNamed(
      Routes.session,
      arguments: data,
    );
  }
}
