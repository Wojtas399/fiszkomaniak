import 'package:fiszkomaniak/components/confirmation_app_bar.dart';
import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_event.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';

class FlashcardPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FlashcardPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardPreviewBloc, FlashcardPreviewState>(
      builder: (BuildContext context, FlashcardPreviewState state) {
        if (state.displaySaveConfirmation) {
          return const _ConfirmationAppBar();
        }
        return const _DefaultAppBar();
      },
    );
  }
}

class _DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DefaultAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBarWithCloseButton(
      label: 'Fiszka',
      actions: [
        CustomIconButton(
          icon: MdiIcons.delete,
          onPressed: () {
            context
                .read<FlashcardPreviewBloc>()
                .add(FlashcardPreviewEventRemoveFlashcard());
          },
        ),
      ],
    );
  }
}

class _ConfirmationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ConfirmationAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return ConfirmationAppBar(
      onAccept: () {
        Utils.unfocusElements();
        context
            .read<FlashcardPreviewBloc>()
            .add(FlashcardPreviewEventSaveChanges());
      },
      onCancel: () {
        Utils.unfocusElements();
        context
            .read<FlashcardPreviewBloc>()
            .add(FlashcardPreviewEventResetChanges());
      },
    );
  }
}
