import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_event.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_content.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_popup_menu.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/group_preview_state.dart';

class GroupPreview extends StatelessWidget {
  final String groupId;

  const GroupPreview({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _GroupPreviewBlocProvider(
      groupId: groupId,
      child: BlocBuilder<GroupPreviewBloc, GroupPreviewState>(
        builder: (BuildContext context, GroupPreviewState state) {
          final Group? group = state.group;
          return Scaffold(
            appBar: AppBarWithCloseButton(
              label: 'Grupa',
              actions: [
                GroupPreviewPopupMenu(
                  onPopupActionSelected: (GroupPopupAction action) {
                    _managePopupAction(context, action);
                  },
                ),
              ],
            ),
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: group != null
                    ? GroupPreviewContent(group: group)
                    : const Center(
                        child: Text('The group does not exist already.'),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _managePopupAction(
    BuildContext context,
    GroupPopupAction action,
  ) async {
    switch (action) {
      case GroupPopupAction.edit:
        context.read<GroupPreviewBloc>().add(GroupPreviewEventEdit());
        break;
      case GroupPopupAction.addFlashcards:
        context.read<GroupPreviewBloc>().add(GroupPreviewEventAddFlashcards());
        break;
      case GroupPopupAction.remove:
        context.read<GroupPreviewBloc>().add(GroupPreviewEventRemove());
        break;
    }
  }
}

class _GroupPreviewBlocProvider extends StatelessWidget {
  final String groupId;
  final Widget child;

  const _GroupPreviewBlocProvider({
    Key? key,
    required this.groupId,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => GroupPreviewBloc(
        groupsBloc: context.read<GroupsBloc>(),
        dialogs: Dialogs(),
      )..add(GroupPreviewEventInitialize(groupId: groupId)),
      child: child,
    );
  }
}
