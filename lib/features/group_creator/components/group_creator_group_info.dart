import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/textfields/custom_textfield.dart';
import '../bloc/group_creator_bloc.dart';
import '../group_creator_mode.dart';

class GroupCreatorGroupInfo extends StatelessWidget {
  final _groupNameController = TextEditingController();
  final _nameForQuestionsController = TextEditingController();
  final _nameForAnswersController = TextEditingController();

  GroupCreatorGroupInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        final GroupCreatorMode mode = state.mode;
        if (mode is GroupCreatorEditMode) {
          if (mode.group.name == state.groupName) {
            _groupNameController.text = mode.group.name;
          }
          if (mode.group.nameForQuestions == state.nameForQuestions) {
            _nameForQuestionsController.text = mode.group.nameForQuestions;
          }
          if (mode.group.nameForAnswers == state.nameForAnswers) {
            _nameForAnswersController.text = mode.group.nameForAnswers;
          }
        }
        return Column(
          children: [
            CustomTextField(
              icon: MdiIcons.folder,
              label: 'Nazwa grupy fiszek',
              controller: _groupNameController,
              onChanged: (String value) => _onGroupNameChanged(context, value),
            ),
            CustomTextField(
              icon: MdiIcons.file,
              label: 'Nazwa dla pytań',
              controller: _nameForQuestionsController,
              onChanged: (String value) => _onNameForQuestionsChanged(
                context,
                value,
              ),
            ),
            CustomTextField(
              icon: MdiIcons.fileReplace,
              label: 'Nazwa dla odpowiedzi',
              controller: _nameForAnswersController,
              onChanged: (String value) => _onNameForAnswersChanged(
                context,
                value,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onGroupNameChanged(BuildContext context, String value) {
    context
        .read<GroupCreatorBloc>()
        .add(GroupCreatorEventGroupNameChanged(groupName: value));
  }

  void _onNameForQuestionsChanged(BuildContext context, String value) {
    context
        .read<GroupCreatorBloc>()
        .add(GroupCreatorEventNameForQuestionsChanged(
          nameForQuestions: value,
        ));
  }

  void _onNameForAnswersChanged(BuildContext context, String value) {
    context.read<GroupCreatorBloc>().add(GroupCreatorEventNameForAnswersChanged(
          nameForAnswers: value,
        ));
  }
}
