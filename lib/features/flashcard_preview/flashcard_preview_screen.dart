import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../providers/dialogs_provider.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/flashcards/delete_flashcard_use_case.dart';
import '../../domain/use_cases/flashcards/update_flashcard_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/flashcard_preview_bloc.dart';
import 'components/flashcard_preview_content.dart';

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
    return BlocProvider(
      create: (BuildContext context) => FlashcardPreviewBloc(
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        getCourseUseCase: GetCourseUseCase(
          coursesInterface: context.read<CoursesInterface>(),
        ),
        updateFlashcardUseCase: UpdateFlashcardUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        deleteFlashcardUseCase: DeleteFlashcardUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
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
          DialogsProvider.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          DialogsProvider.closeLoadingDialog(context);
          final FlashcardPreviewInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info, context);
          }
        } else if (blocStatus is BlocStatusError) {
          DialogsProvider.closeLoadingDialog(context);
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
      DialogsProvider.showSnackbarWithMessage(
        'Pomyślnie zaktualizowano fiszkę',
      );
    } else if (info == FlashcardPreviewInfo.flashcardHasBeenDeleted) {
      Navigation.moveBack();
      DialogsProvider.showSnackbarWithMessage('Pomyślnie usunięto fiszkę');
    }
  }

  void _manageError(FlashcardPreviewError error) {
    switch (error) {
      case FlashcardPreviewError.flashcardIsIncomplete:
        DialogsProvider.showDialogWithMessage(
          title: 'Niekompletna fiszka',
          message:
              'Pytanie lub odpowiedź pozostały puste. Uzupełnij je aby móc zapisać zmiany.',
        );
        break;
    }
  }
}
