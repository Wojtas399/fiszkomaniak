import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../domain/use_cases/flashcards/save_edited_flashcards_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../interfaces/achievements_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../models/bloc_status.dart';
import 'bloc/flashcards_editor_bloc.dart';
import 'components/flashcards_editor_content.dart';

class FlashcardsEditorScreen extends StatelessWidget {
  final String groupId;

  const FlashcardsEditorScreen({
    super.key,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return _FlashcardsEditorBlocProvider(
      groupId: groupId,
      child: const _FlashcardsEditorBlocListener(
        child: FlashcardsEditorContent(),
      ),
    );
  }
}

class _FlashcardsEditorBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const _FlashcardsEditorBlocProvider({
    required this.groupId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => FlashcardsEditorBloc(
        getGroupUseCase: GetGroupUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        saveEditedFlashcardsUseCase: SaveEditedFlashcardsUseCase(
          groupsInterface: context.read<GroupsInterface>(),
          achievementsInterface: context.read<AchievementsInterface>(),
        ),
      )..add(FlashcardsEditorEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}

class _FlashcardsEditorBlocListener extends StatelessWidget {
  final Widget child;

  const _FlashcardsEditorBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardsEditorBloc, FlashcardsEditorState>(
      listener: (BuildContext context, FlashcardsEditorState state) {
        final BlocStatus blocStatus = state.status;
        if (blocStatus is BlocStatusLoading) {
          Dialogs.showLoadingDialog();
        } else if (blocStatus is BlocStatusComplete) {
          Dialogs.closeLoadingDialog(context);
          final FlashcardsEditorInfo? info = blocStatus.info;
          if (info != null) {
            _manageInfo(info);
          }
        } else if (blocStatus is BlocStatusError) {
          Dialogs.closeLoadingDialog(context);
          final FlashcardsEditorError? error = blocStatus.error;
          if (error != null) {
            _manageError(error);
          }
        }
      },
      child: child,
    );
  }

  void _manageInfo(FlashcardsEditorInfo info) {
    switch (info) {
      case FlashcardsEditorInfo.editedFlashcardsHaveBeenSaved:
        Dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
        break;
    }
  }

  void _manageError(FlashcardsEditorError error) {
    switch (error) {
      case FlashcardsEditorError.noChangesHaveBeenMade:
        Dialogs.showDialogWithMessage(
          title: 'Brak zmian',
          message:
              'Nie wprowadzono żadnych zmian do fiszek. Wprowadź je, aby móc wykonać tę operację.',
        );
        break;
      case FlashcardsEditorError.incompleteFlashcardsExist:
        Dialogs.showDialogWithMessage(
          title: 'Niekompletne fiszki',
          message: 'Niektóry fiszki nie zostały w pełni uzupełnione.',
        );
        break;
    }
  }
}
