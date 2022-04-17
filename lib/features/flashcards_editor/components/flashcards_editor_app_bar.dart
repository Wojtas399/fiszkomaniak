import 'package:fiszkomaniak/components/app_bar_with_close_button.dart';
import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FlashcardsEditorAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FlashcardsEditorAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsEditorBloc, FlashcardsEditorState>(
      builder: (BuildContext context, FlashcardsEditorState state) {
        return AppBarWithCloseButton(
          label: state.group?.name ?? '',
          actions: [
            CustomIconButton(
              icon: MdiIcons.contentSave,
              onPressed: () {
                context
                    .read<FlashcardsEditorBloc>()
                    .add(FlashcardsEditorEventSave());
              },
            ),
          ],
        );
      },
    );
  }
}
