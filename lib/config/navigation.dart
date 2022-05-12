import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:fiszkomaniak/config/slide_up_route_animation.dart';
import 'package:fiszkomaniak/features/course_creator/course_creator_mode.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_page.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../features/flashcard_preview/bloc/flashcard_preview_state.dart';
import '../features/home/home.dart';
import '../features/learning_process/learning_process_data.dart';

class Navigation {
  void moveBack({Object? objectToReturn}) {
    HomeRouter.navigatorKey.currentState?.pop(objectToReturn);
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
    HomeRouter.navigatorKey.currentState?.popUntil(
      ModalRoute.withName(HomeRouter.home),
    );
  }

  void navigateToSettings() {
    HomeRouter.navigatorKey.currentState?.pushNamed(HomeRouter.settings);
  }

  Future<void> navigateToCourseCreator(CourseCreatorMode mode) async {
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

  Future<void> navigateToGroupCreator(GroupCreatorMode mode) async {
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

  void navigateToSessionCreator(SessionCreatorMode mode) async {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.sessionCreator,
      arguments: mode,
    );
  }

  void navigateToGroupSelection() {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupSelection,
    );
  }

  void navigateToFlashcardsEditor(FlashcardsEditorMode mode) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.flashcardsEditor,
      arguments: mode,
    );
  }

  void navigateToCourseGroupsPreview(String courseId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.courseGroupsPreview,
      arguments: courseId,
    );
  }

  void navigateToGroupFlashcardsPreview(String groupId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupFlashcardsPreview,
      arguments: groupId,
    );
  }

  void navigateToGroupPreview(String groupId) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.groupPreview,
      arguments: groupId,
    );
  }

  void navigateToFlashcardPreview(String groupId, int flashcardIndex) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.flashcardPreview,
      arguments: FlashcardPreviewParams(
        groupId: groupId,
        flashcardIndex: flashcardIndex,
      ),
    );
  }

  void navigateToSessionPreview(SessionPreviewMode mode) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.sessionPreview,
      arguments: mode,
    );
  }

  void navigateToLearningProcess(LearningProcessData data) {
    HomeRouter.navigatorKey.currentState?.pushNamed(
      HomeRouter.session,
      arguments: data,
    );
  }
}
