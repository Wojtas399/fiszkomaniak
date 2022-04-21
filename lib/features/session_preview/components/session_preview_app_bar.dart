import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/confirmation_app_bar.dart';
import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SessionPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        return state.mode == SessionMode.normal && state.haveChangesBeenMade
            ? ConfirmationAppBar(
                onAccept: () => _saveChanges(context),
                onCancel: () => _cancelChanges(context),
              )
            : _DefaultAppBar(
                title: state.mode == SessionMode.normal
                    ? 'Sesja'
                    : 'Szybka sesja');
      },
    );
  }

  void _saveChanges(BuildContext context) {
    context.read<SessionPreviewBloc>().add(SessionPreviewEventSaveChanges());
  }

  void _cancelChanges(BuildContext context) {
    context.read<SessionPreviewBloc>().add(SessionPreviewEventResetChanges());
  }
}

class _DefaultAppBar extends StatelessWidget {
  final String title;

  const _DefaultAppBar({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBarWithCloseButton(
      label: title,
      actions: [
        CustomIconButton(
          icon: MdiIcons.delete,
          onPressed: () => _deleteSession(context),
        ),
      ],
    );
  }

  void _deleteSession(BuildContext context) {
    context.read<SessionPreviewBloc>().add(SessionPreviewEventDeleteSession());
  }
}
