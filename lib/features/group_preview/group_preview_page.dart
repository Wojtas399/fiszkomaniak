import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_content.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_popup_menu.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/groups/groups_state.dart';

class GroupPreview extends StatelessWidget {
  final String groupId;

  const GroupPreview({Key? key, required this.groupId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupsBloc, GroupsState>(
      builder: (BuildContext context, GroupsState state) {
        final Group? group = state.getGroupById(groupId);
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
    );
  }

  void _managePopupAction(BuildContext context, GroupPopupAction action) {
    switch (action) {
      case GroupPopupAction.edit:
        // TODO: Handle this case.
        break;
      case GroupPopupAction.addFlashcards:
        // TODO: Handle this case.
        break;
      case GroupPopupAction.remove:
        context
            .read<GroupsBloc>()
            .add(GroupsEventRemoveGroup(groupId: groupId));
        break;
    }
  }
}
