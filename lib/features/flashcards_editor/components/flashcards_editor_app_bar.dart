import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bars/app_bar_with_close_button.dart';
import '../../../components/custom_icon_button.dart';
import '../../../utils/utils.dart';
import '../bloc/flashcards_editor_bloc.dart';

class FlashcardsEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FlashcardsEditorAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final String? groupName = context.select(
      (FlashcardsEditorBloc bloc) => bloc.state.group?.name,
    );
    return CustomAppBar(
      label: groupName ?? '',
      actions: [
        CustomIconButton(
          icon: MdiIcons.contentSave,
          onPressed: () => _onPressedSaveButton(context),
        ),
      ],
    );
  }

  Future<void> _onPressedSaveButton(BuildContext context) async {
    Utils.unfocusElements();
    context.read<FlashcardsEditorBloc>().add(
          FlashcardsEditorEventSave(),
        );
  }
}
