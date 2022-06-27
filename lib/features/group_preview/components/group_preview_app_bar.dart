import 'package:fiszkomaniak/components/popup_menu.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/group_creator/bloc/group_creator_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../../../domain/entities/group.dart';
import '../bloc/group_preview_bloc.dart';

class GroupPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupPreviewAppBar({super.key});

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
      _navigateToGroupCreatorInEditMode(context);
    } else if (actionIndex == 1) {
      context.read<GroupPreviewBloc>().add(GroupPreviewEventRemoveGroup());
    }
  }

  void _navigateToGroupCreatorInEditMode(BuildContext context) {
    final Group? group = context.read<GroupPreviewBloc>().state.group;
    if (group != null) {
      context.read<Navigation>().navigateToGroupCreator(
            GroupCreatorEditMode(group: group),
          );
    }
  }
}
