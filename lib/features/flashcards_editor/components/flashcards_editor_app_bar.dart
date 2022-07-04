import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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

  void _onPressedSaveButton(BuildContext context) {
    Utils.unfocusElements();
    context.read<FlashcardsEditorBloc>().add(FlashcardsEditorEventSave());
  }
}
