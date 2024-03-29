import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/button.dart';
import '../../../config/navigation.dart';
import '../bloc/group_selection_bloc.dart';

class GroupSelectionButton extends StatelessWidget {
  const GroupSelectionButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isButtonDisabled = context.select(
      (GroupSelectionBloc bloc) => bloc.state.isButtonDisabled,
    );
    return Button(
      label: 'Rozpocznij dodawanie',
      onPressed: isButtonDisabled ? null : () => _onPressed(context),
    );
  }

  void _onPressed(BuildContext context) {
    final String? selectedGroupId =
        context.read<GroupSelectionBloc>().state.selectedGroup?.id;
    if (selectedGroupId != null) {
      Navigation.navigateToFlashcardsEditor(selectedGroupId);
    }
  }
}
