import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';
import '../bloc/group_creator_bloc.dart';
import '../bloc/group_creator_mode.dart';

class GroupCreatorSubmitButton extends StatelessWidget {
  const GroupCreatorSubmitButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        return Button(
          label: _getButtonLabel(state.mode),
          onPressed: state.isButtonDisabled ? null : () => _onPressed(context),
        );
      },
    );
  }

  String _getButtonLabel(GroupCreatorMode mode) {
    if (mode is GroupCreatorCreateMode) {
      return 'utwórz';
    } else if (mode is GroupCreatorEditMode) {
      return 'zapisz';
    }
    return '';
  }

  void _onPressed(BuildContext context) {
    context.read<GroupCreatorBloc>().add(GroupCreatorEventSubmit());
  }
}
