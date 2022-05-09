import 'package:fiszkomaniak/components/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../bloc/group_preview_bloc.dart';
import '../bloc/group_preview_event.dart';

class GroupPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      label: 'Grupa',
      actions: [
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
            _managePopupAction(context, selectedActionIndex);
          },
        ),
      ],
    );
  }

  Future<void> _managePopupAction(
    BuildContext context,
    int actionIndex,
  ) async {
    if (actionIndex == 0) {
      context.read<GroupPreviewBloc>().add(GroupPreviewEventEdit());
    } else if (actionIndex == 1) {
      context.read<GroupPreviewBloc>().add(GroupPreviewEventRemove());
    }
  }
}
