import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionCreatorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionCreatorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final SessionCreatorMode mode = context.select(
      (SessionCreatorBloc bloc) => bloc.state.mode,
    );
    return CustomAppBar(label: _getTitle(mode));
  }

  String _getTitle(SessionCreatorMode mode) {
    if (mode is SessionCreatorCreateMode) {
      return 'Nowa sesja';
    } else if (mode is SessionCreatorEditMode) {
      return 'Edytuj sesję';
    }
    return '';
  }
}
