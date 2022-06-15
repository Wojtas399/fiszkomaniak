import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bar_with_close_button.dart';

class GroupCreatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupCreatorAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupCreatorBloc, GroupCreatorState>(
      builder: (BuildContext context, GroupCreatorState state) {
        return CustomAppBar(label: state.modeTitle);
      },
    );
  }
}
