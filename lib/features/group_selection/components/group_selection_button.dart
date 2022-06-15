import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupSelectionButton extends StatelessWidget {
  const GroupSelectionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupSelectionBloc, GroupSelectionState>(
      builder: (BuildContext context, GroupSelectionState state) {
        return Button(
          label: 'Rozpocznij dodawanie',
          onPressed: state.isButtonDisabled
              ? null
              : () {
                  context
                      .read<GroupSelectionBloc>()
                      .add(GroupSelectionEventButtonPressed());
                },
        );
      },
    );
  }
}
