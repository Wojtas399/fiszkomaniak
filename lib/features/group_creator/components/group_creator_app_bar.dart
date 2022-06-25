import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../bloc/group_creator_mode.dart';

class GroupCreatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupCreatorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final GroupCreatorMode mode = context.select(
      (GroupCreatorBloc bloc) => bloc.state.mode,
    );
    return CustomAppBar(label: _getTitle(mode));
  }

  String _getTitle(GroupCreatorMode mode) {
    if (mode is GroupCreatorCreateMode) {
      return 'Nowa grupa';
    } else if (mode is GroupCreatorEditMode) {
      return 'Edycja grupy';
    }
    return '';
  }
}
