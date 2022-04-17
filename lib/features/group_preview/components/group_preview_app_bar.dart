import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../bloc/group_preview_bloc.dart';
import '../bloc/group_preview_event.dart';
import 'group_preview_popup_menu.dart';

class GroupPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const GroupPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBarWithCloseButton(
      label: 'Grupa',
      actions: [
        GroupPreviewPopupMenu(
          onPopupActionSelected: (GroupPopupAction action) {
            _managePopupAction(context, action);
          },
        ),
      ],
    );
  }

  Future<void> _managePopupAction(
    BuildContext context,
    GroupPopupAction action,
  ) async {
    switch (action) {
      case GroupPopupAction.edit:
        context.read<GroupPreviewBloc>().add(GroupPreviewEventEdit());
        break;
      case GroupPopupAction.addFlashcards:
        context.read<GroupPreviewBloc>().add(GroupPreviewEventAddFlashcards());
        break;
      case GroupPopupAction.remove:
        context.read<GroupPreviewBloc>().add(GroupPreviewEventRemove());
        break;
    }
  }
}
