import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/dialogs/dialogs.dart';
import '../../../components/popup_menu.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../../../config/navigation.dart';
import '../../../domain/entities/group.dart';
import '../../group_creator/bloc/group_creator_mode.dart';
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
      await _deleteGroup(context);
    }
  }

  void _navigateToGroupCreatorInEditMode(BuildContext context) {
    final Group? group = context.read<GroupPreviewBloc>().state.group;
    if (group != null) {
      Navigation.navigateToGroupCreator(
        GroupCreatorEditMode(group: group),
      );
    }
  }

  Future<void> _deleteGroup(BuildContext context) async {
    final GroupPreviewBloc groupPreviewBloc = context.read<GroupPreviewBloc>();
    final bool confirmation = await _askForDeletionOperationConfirmation();
    if (confirmation == true) {
      groupPreviewBloc.add(GroupPreviewEventDeleteGroup());
    }
  }

  Future<bool> _askForDeletionOperationConfirmation() async {
    return await Dialogs.askForConfirmation(
      title: 'Czy na pewno chcesz usunąć grupę?',
      text:
          'Usunięcie grupy spowoduje również usunięcie wszystkich fiszek oraz sesji z nią powiązanych.',
      confirmButtonText: 'Usuń',
    );
  }
}
