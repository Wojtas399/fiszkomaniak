import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../providers/dialogs_provider.dart';
import '../../components/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../components/flashcards_stack/flashcards_stack_model.dart';
import '../../components/flashcards_stack/components/flashcards_stack_bloc_provider.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/use_cases/achievements/add_finished_session_use_case.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/sessions/save_session_progress_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/sessions/delete_session_use_case.dart';
import '../../features/home/home.dart';
import '../../interfaces/achievements_interface.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../interfaces/sessions_interface.dart';
import '../../interfaces/user_interface.dart';
import '../../interfaces/notifications_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/learning_process_bloc.dart';
import 'components/learning_process_content.dart';
import 'learning_process_arguments.dart';

class LearningProcessScreen extends StatelessWidget {
  final LearningProcessArguments arguments;

  const LearningProcessScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return _LearningProcessBlocProvider(
      arguments: arguments,
      child: FlashcardsStackBlocProvider(
        child: _LearningProcessBlocListener(
          child: _FlashcardsStackListener(
            child: WillPopScope(
              onWillPop: () async {
                if (Navigator.of(context).userGestureInProgress) {
                  return false;
                } else {
                  return true;
                }
              },
              child: const LearningProcessContent(),
            ),
          ),
        ),
      ),
    );
  }
}

class _LearningProcessBlocProvider extends StatelessWidget {
  final LearningProcessArguments arguments;
  final Widget child;

  const _LearningProcessBlocProvider({
    required this.arguments,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LearningProcessBloc(
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        saveSessionProgressUseCase: SaveSessionProgressUseCase(
          groupsInterface: context.read<GroupsInterface>(),
          achievementsInterface: context.read<AchievementsInterface>(),
          userInterface: context.read<UserInterface>(),
        ),
        addFinishedSessionUseCase: AddFinishedSessionUseCase(
          achievementsInterface: context.read<AchievementsInterface>(),
        ),
        deleteSessionUseCase: DeleteSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
          notificationsInterface: context.read<NotificationsInterface>(),
        ),
      )..add(
          LearningProcessEventInitialize(
            sessionId: arguments.sessionId,
            groupId: arguments.groupId,
            duration: arguments.duration,
            flashcardsType: arguments.flashcardsType,
            areQuestionsAndAnswersSwapped:
                arguments.areQuestionsAndAnswersSwapped,
          ),
        ),
      child: child,
    );
  }
}

class _LearningProcessBlocListener extends StatelessWidget {
  final Widget child;

  const _LearningProcessBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LearningProcessBloc, LearningProcessState>(
      listener: (BuildContext context, LearningProcessState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final LearningProcessInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(
              info,
              _createStackFlashcards(
                state.flashcardsInStack,
                state.areQuestionsAndAnswersSwapped,
              ),
              context,
            );
          }
        }
      },
      child: child,
    );
  }

  List<StackFlashcard> _createStackFlashcards(
    List<Flashcard> flashcards,
    bool areQuestionsAndAnswersSwapped,
  ) {
    return flashcards
        .map(
          (Flashcard flashcard) => StackFlashcard(
            index: flashcard.index,
            question: areQuestionsAndAnswersSwapped
                ? flashcard.answer
                : flashcard.question,
            answer: areQuestionsAndAnswersSwapped
                ? flashcard.question
                : flashcard.answer,
          ),
        )
        .toList();
  }

  void _manageInfo(
    LearningProcessInfo infoType,
    List<StackFlashcard> flashcardsInfo,
    BuildContext context,
  ) {
    switch (infoType) {
      case LearningProcessInfo.initialDataHaveBeenSet:
      case LearningProcessInfo.flashcardsStackHasBeenReset:
        _initializeFlashcardsStack(flashcardsInfo, context);
        break;
      case LearningProcessInfo.sessionHasBeenFinished:
        _backHome(context);
        break;
      case LearningProcessInfo.sessionHasBeenAborted:
        Navigation.moveBack();
        break;
    }
  }

  void _initializeFlashcardsStack(
    List<StackFlashcard> flashcardsInfo,
    BuildContext context,
  ) {
    context
        .read<FlashcardsStackBloc>()
        .add(FlashcardsStackEventInitialize(flashcards: flashcardsInfo));
  }

  void _backHome(BuildContext context) {
    Navigation.backHome();
    context.read<HomePageController>().moveToPage(0);
  }
}

class _FlashcardsStackListener extends StatelessWidget {
  final Widget child;

  const _FlashcardsStackListener({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardsStackBloc, FlashcardsStackState>(
      listener: (BuildContext context, FlashcardsStackState state) {
        final FlashcardsStackStatus status = state.status;
        if (status is FlashcardsStackStatusMovedLeft) {
          _forgottenFlashcard(context, status.flashcardIndex);
        } else if (status is FlashcardsStackStatusMovedRight) {
          _rememberedFlashcard(context, status.flashcardIndex);
        }
      },
      child: child,
    );
  }

  void _forgottenFlashcard(BuildContext context, int flashcardIndex) {
    context
        .read<LearningProcessBloc>()
        .add(LearningProcessEventForgottenFlashcard(
          flashcardIndex: flashcardIndex,
        ));
  }

  void _rememberedFlashcard(BuildContext context, int flashcardIndex) {
    context
        .read<LearningProcessBloc>()
        .add(LearningProcessEventRememberedFlashcard(
          flashcardIndex: flashcardIndex,
        ));
  }
}
