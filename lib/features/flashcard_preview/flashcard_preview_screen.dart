import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/flashcards/remove_flashcard_use_case.dart';
import '../../domain/use_cases/flashcards/update_flashcard_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/flashcard_preview_bloc.dart';
import 'components/flashcard_preview_content.dart';
import 'flashcard_preview_dialogs.dart';


class FlashcardPreviewScreenArguments extends Equatable {
  final String groupId;
  final int flashcardIndex;

  const FlashcardPreviewScreenArguments({
    required this.groupId,
    required this.flashcardIndex,
  });

  @override
  List<Object> get props => [groupId, flashcardIndex];
}

class FlashcardPreviewScreen extends StatelessWidget {
  final FlashcardPreviewScreenArguments arguments;

  const FlashcardPreviewScreen({
    super.key,
    required this.arguments,
  });

  @override
  Widget build(BuildContext context) {
    return _FlashcardPreviewBlocProvider(
      groupId: arguments.groupId,
      flashcardIndex: arguments.flashcardIndex,
      child: const _FlashcardPreviewBlocListener(
        child: FlashcardPreviewContent(),
      ),
    );
  }
}

class _FlashcardPreviewBlocProvider extends StatelessWidget {
  final String groupId;
  final int flashcardIndex;
  final Widget child;

  const _FlashcardPreviewBlocProvider({
    required this.groupId,
    required this.flashcardIndex,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final GroupsInterface groupsInterface = context.read<GroupsInterface>();
    return BlocProvider(
      create: (BuildContext context) => FlashcardPreviewBloc(
        getGroupUseCase: GetGroupUseCase(groupsInterface: groupsInterface),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        updateFlashcardUseCase: UpdateFlashcardUseCase(
          groupsInterface: groupsInterface,
        ),
        removeFlashcardUseCase: RemoveFlashcardUseCase(
          groupsInterface: groupsInterface,
        ),
        flashcardPreviewDialogs: FlashcardPreviewDialogs(),
      )..add(
          FlashcardPreviewEventInitialize(
            groupId: groupId,
            flashcardIndex: flashcardIndex,
          ),
        ),
      child: child,
    );
  }
}

class _FlashcardPreviewBlocListener extends StatelessWidget {
  final Widget child;

  const _FlashcardPreviewBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardPreviewBloc, FlashcardPreviewState>(
      listener: (BuildContext context, FlashcardPreviewState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final FlashcardPreviewInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          Dialogs.closeLoadingDialog(context);
          final FlashcardPreviewError? error = blocStatus.error;
          if (error != null) {
            _manageError(error);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(
    FlashcardPreviewInfo info,
    BuildContext context,
  ) {
    if (info == FlashcardPreviewInfo.flashcardHasBeenUpdated) {
      Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano fiszkę');
    } else if (info == FlashcardPreviewInfo.flashcardHasBeenDeleted) {
      context.read<Navigation>().moveBack();
      Dialogs.showSnackbarWithMessage('Pomyślnie usunięto fiszkę');
    }
  }

  void _manageError(FlashcardPreviewError error) {
    switch (error) {
      case FlashcardPreviewError.flashcardIsIncomplete:
        Dialogs.showDialogWithMessage(
          title: 'Niekompletna fiszka',
          message:
              'Pytanie lub odpowiedź pozostały puste. Uzupełnij je aby móc zapisać zmiany.',
        );
        break;
    }
  }
}
