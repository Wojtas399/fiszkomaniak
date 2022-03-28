import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_flashcards_state.dart';
import 'package:fiszkomaniak/features/group_preview/components/group_preview_information.dart';
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
      builder: (BuildContext context, GroupsState groupsState) {
        final Group group = groupsState.getGroupById(groupId);
        return Scaffold(
          appBar: AppBarWithCloseButton(
            label: 'Grupa',
            actions: [
              GroupPreviewPopupMenu(
                onPopupActionSelected: (GroupPopupAction action) {
                  _managePopupAction(action);
                },
              ),
            ],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      const SizedBox(height: 16),
                      GroupPreviewInformation(
                        courseId: group.courseId,
                        nameForQuestions: group.nameForQuestions,
                        nameForAnswers: group.nameForAnswers,
                      ),
                      GroupPreviewFlashcardsState(groupId: groupId),
                    ],
                  ),
                  Button(
                    label: 'przeglądaj fiszki',
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _managePopupAction(GroupPopupAction action) {
    //TODO
  }
}
