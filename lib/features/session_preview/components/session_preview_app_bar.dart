import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_event.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/components/popup_menu.dart';
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
        return AppBarWithCloseButton(
          label: state.mode == SessionMode.normal ? 'Sesja' : 'Szybka sesja',
          actions: state.mode == SessionMode.quick
              ? []
              : [
                  PopupMenu(
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
                  ),
                ],
        );
      },
    );
  }

  void _managePopupActions(BuildContext context, int selectedActionIndex) {
    if (selectedActionIndex == 0) {
      context.read<SessionPreviewBloc>().add(SessionPreviewEventEditSession());
    } else if (selectedActionIndex == 1) {
      context
          .read<SessionPreviewBloc>()
          .add(SessionPreviewEventDeleteSession());
    }
  }
}
