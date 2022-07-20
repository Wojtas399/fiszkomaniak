import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcards_statuses_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/remove_session_use_case.dart';
import 'package:fiszkomaniak/components/flashcards_stack/components/flashcards_stack_bloc_provider.dart';
import 'package:fiszkomaniak/features/home/home.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_content.dart';
import 'package:fiszkomaniak/features/learning_process/learning_process_dialogs.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../components/flashcards_stack/flashcards_stack_model.dart';
import 'learning_process_data.dart';

class LearningProcessScreen extends StatelessWidget {
  final LearningProcessData data;

  const LearningProcessScreen({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return _LearningProcessBlocProvider(
      data: data,
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
  final LearningProcessData data;
  final Widget child;

  const _LearningProcessBlocProvider({
    required this.data,
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
        updateFlashcardsStatusesUseCase: UpdateFlashcardsStatusesUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        removeSessionUseCase: RemoveSessionUseCase(
          sessionsInterface: context.read<SessionsInterface>(),
        ),
        learningProcessDialogs: LearningProcessDialogs(),
      )..add(LearningProcessEventInitialize(data: data)),
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
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final LearningProcessInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(
              infoType,
              state.stackFlashcards,
              context,
            );
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(
    LearningProcessInfoType infoType,
    List<StackFlashcard> flashcardsInfo,
    BuildContext context,
  ) {
    switch (infoType) {
      case LearningProcessInfoType.initialDataHasBeenLoaded:
      case LearningProcessInfoType.flashcardsStackHasBeenReset:
        _initializeFlashcardsStack(flashcardsInfo, context);
        break;
      case LearningProcessInfoType.sessionHasBeenFinished:
        _backHome(context);
        break;
      case LearningProcessInfoType.sessionHasBeenAborted:
        context.read<Navigation>().moveBack();
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
    context.read<Navigation>().backHome();
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
