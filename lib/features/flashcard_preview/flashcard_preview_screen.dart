import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/remove_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/flashcards/update_flashcard_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/flashcard_preview_dialogs.dart';
import 'package:fiszkomaniak/features/flashcard_preview/components/flashcard_preview_content.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      )..add(FlashcardPreviewEventInitialize(
          groupId: groupId,
          flashcardIndex: flashcardIndex,
        )),
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
          final FlashcardPreviewInfoType? infoType = blocStatus.info;
          if (infoType != null) {
            _manageInfoType(infoType, context);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfoType(
    FlashcardPreviewInfoType infoType,
    BuildContext context,
  ) {
    if (infoType == FlashcardPreviewInfoType.flashcardIsIncomplete) {
      Dialogs.showDialogWithMessage(
        title: 'Niekompletna fiszka',
        message:
            'Pytanie lub odpowiedź pozostały puste. Uzupełnij je aby móc zapisać zmiany.',
      );
    } else if (infoType == FlashcardPreviewInfoType.flashcardHasBeenUpdated) {
      Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano fiszkę');
    } else if (infoType == FlashcardPreviewInfoType.flashcardHasBeenRemoved) {
      context.read<Navigation>().moveBack();
      Dialogs.showSnackbarWithMessage('Pomyślnie usunięto fiszkę');
    }
  }
}
