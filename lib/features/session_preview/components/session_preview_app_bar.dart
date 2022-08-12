import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../../../config/navigation.dart';
import '../../../providers/dialogs_provider.dart';
import '../../../components/popup_menu.dart';
import '../../../domain/entities/session.dart';
import '../../session_creator/bloc/session_creator_mode.dart';
import '../bloc/session_preview_bloc.dart';
import '../bloc/session_preview_mode.dart';

class SessionPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const SessionPreviewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final SessionPreviewMode? mode = context.select(
      (SessionPreviewBloc bloc) => bloc.state.mode,
    );
    return CustomAppBar(
      label: _getLabel(mode),
      actions: mode is SessionPreviewModeQuick ? [] : [const _SessionOptions()],
    );
  }

  String _getLabel(SessionPreviewMode? mode) {
    if (mode is SessionPreviewModeNormal) {
      return 'Sesja';
    } else if (mode is SessionPreviewModeQuick) {
      return 'Szybka sesja';
    }
    return '--';
  }
}

class _SessionOptions extends StatelessWidget {
  const _SessionOptions();

  @override
  Widget build(BuildContext context) {
    return PopupMenu(
      items: [
        PopupMenuItemParams(
          icon: MdiIcons.squareEditOutline,
          label: 'Edytuj',
        ),
        PopupMenuItemParams(
          icon: MdiIcons.deleteOutline,
          label: 'Usuń',
        ),
      ],
      onPopupActionSelected: (int selectedActionIndex) {
        _managePopupActions(context, selectedActionIndex);
      },
    );
  }

  Future<void> _managePopupActions(
    BuildContext context,
    int selectedActionIndex,
  ) async {
    if (selectedActionIndex == 0) {
      _navigateToSessionEditor(context);
    } else if (selectedActionIndex == 1) {
      await _deleteSession(context);
    }
  }

  void _navigateToSessionEditor(BuildContext context) {
    final Session? session = context.read<SessionPreviewBloc>().state.session;
    if (session != null) {
      Navigation.navigateToSessionCreator(
        SessionCreatorEditMode(session: session),
      );
    }
  }

  Future<void> _deleteSession(BuildContext context) async {
    final SessionPreviewBloc bloc = context.read<SessionPreviewBloc>();
    final bool confirmation = await _askForSessionDeletionConfirmation();
    if (confirmation) {
      bloc.add(
        SessionPreviewEventDeleteSession(),
      );
    }
  }

  Future<bool> _askForSessionDeletionConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Usuwanie sesji',
      text: 'Czy na pewno chcesz usunąć tą sesję?',
      confirmButtonText: 'Usuń',
    );
  }
}
