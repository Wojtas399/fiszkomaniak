import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupCreatorGroupInfo extends StatelessWidget {
  final TextEditingController groupNameController = TextEditingController();
  final TextEditingController nameForQuestionsController =
      TextEditingController();
  final TextEditingController nameForAnswersController =
      TextEditingController();

  GroupCreatorGroupInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        final GroupCreatorMode mode = state.mode;
        if (mode is GroupCreatorEditMode) {
          if (mode.group.name == state.groupName) {
            groupNameController.text = mode.group.name;
          }
          if (mode.group.nameForQuestions == state.nameForQuestions) {
            nameForQuestionsController.text = mode.group.nameForQuestions;
          }
          if (mode.group.nameForAnswers == state.nameForAnswers) {
            nameForAnswersController.text = mode.group.nameForAnswers;
          }
        }
        return Column(
          children: [
            CustomTextField(
              icon: MdiIcons.folder,
              label: 'Nazwa grupy fiszek',
              controller: groupNameController,
              onChanged: (String value) {
                context
                    .read<GroupCreatorBloc>()
                    .add(GroupCreatorEventGroupNameChanged(groupName: value));
              },
            ),
            CustomTextField(
              icon: MdiIcons.file,
              label: 'Nazwa dla pytań',
              controller: nameForQuestionsController,
              onChanged: (String value) {
                context
                    .read<GroupCreatorBloc>()
                    .add(GroupCreatorEventNameForQuestionsChanged(
                      nameForQuestions: value,
                    ));
              },
            ),
            CustomTextField(
              icon: MdiIcons.fileReplace,
              label: 'Nazwa dla odpowiedzi',
              controller: nameForAnswersController,
              onChanged: (String value) {
                context
                    .read<GroupCreatorBloc>()
                    .add(GroupCreatorEventNameForAnswersChanged(
                      nameForAnswers: value,
                    ));
              },
            ),
          ],
        );
      },
    );
  }
}
