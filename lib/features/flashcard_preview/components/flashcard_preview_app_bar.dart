import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';

class FlashcardPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FlashcardPreviewAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool haveQuestionOrAnswerBeenChanged = context.select(
      (FlashcardPreviewBloc bloc) => bloc.state.haveQuestionOrAnswerBeenChanged,
    );
    if (haveQuestionOrAnswerBeenChanged) {
      return const _ConfirmationAppBar();
    }
    return const _DefaultAppBar();
  }
}

class _DefaultAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _DefaultAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      label: 'Fiszka',
      actions: [
        CustomIconButton(
          icon: MdiIcons.delete,
          onPressed: () => _onDelete(context),
        ),
      ],
    );
  }

  void _onDelete(BuildContext context) {
    context
        .read<FlashcardPreviewBloc>()
        .add(FlashcardPreviewEventRemoveFlashcard());
  }
}

class _ConfirmationAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const _ConfirmationAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      title: const Text('Zapisać zmiany?'),
      actions: [
        CustomIconButton(
          icon: MdiIcons.close,
          onPressed: () => _onCancel(context),
        ),
        CustomIconButton(
          icon: MdiIcons.check,
          onPressed: () => _onAccept(context),
        ),
      ],
    );
  }

  void _onCancel(BuildContext context) {
    Utils.unfocusElements();
    context
        .read<FlashcardPreviewBloc>()
        .add(FlashcardPreviewEventResetChanges());
  }

  void _onAccept(BuildContext context) {
    Utils.unfocusElements();
    context
        .read<FlashcardPreviewBloc>()
        .add(FlashcardPreviewEventSaveChanges());
  }
}
