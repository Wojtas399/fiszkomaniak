import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_event.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupCreatorSubmitButton extends StatelessWidget {
  const GroupCreatorSubmitButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        return Button(
          label: state.modeButtonText,
          onPressed: state.isButtonDisabled
              ? null
              : () {
                  context
                      .read<GroupCreatorBloc>()
                      .add(GroupCreatorEventSubmit());
                },
        );
      },
    );
  }
}
