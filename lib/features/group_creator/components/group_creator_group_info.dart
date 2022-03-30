import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class GroupCreatorGroupInfo extends StatelessWidget {
  const GroupCreatorGroupInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomTextField(
          icon: MdiIcons.folder,
          label: 'Nazwa grupy fiszek',
          onChanged: (String value) {
            context
                .read<GroupCreatorBloc>()
                .add(GroupCreatorEventGroupNameChanged(groupName: value));
          },
        ),
        CustomTextField(
          icon: MdiIcons.file,
          label: 'Nazwa dla pytań',
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
  }
}
