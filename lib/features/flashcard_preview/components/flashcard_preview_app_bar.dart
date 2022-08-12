import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';
import '../../../components/custom_icon_button.dart';
import '../../../providers/dialogs_provider.dart';
import '../../../utils/utils.dart';
import '../bloc/flashcard_preview_bloc.dart';

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
          onPressed: () => _onDeleteActionPressed(context),
        ),
      ],
    );
  }

  Future<void> _onDeleteActionPressed(BuildContext context) async {
    final FlashcardPreviewBloc bloc = context.read<FlashcardPreviewBloc>();
    final bool confirmation = await _askForFlashcardDeletionConfirmation();
    if (confirmation) {
      bloc.add(
        FlashcardPreviewEventDeleteFlashcard(),
      );
    }
  }

  Future<bool> _askForFlashcardDeletionConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Usuwanie',
      text: 'Czy na pewno chcesz usunąć tę fiszkę?',
      confirmButtonText: 'Usuń',
    );
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
    _resetChanges(context);
  }

  Future<void> _onAccept(BuildContext context) async {
    Utils.unfocusElements();
    await _saveChanges(context);
  }

  void _resetChanges(BuildContext context) {
    context
        .read<FlashcardPreviewBloc>()
        .add(FlashcardPreviewEventResetChanges());
  }

  Future<void> _saveChanges(BuildContext context) async {
    final FlashcardPreviewBloc bloc = context.read<FlashcardPreviewBloc>();
    final bool confirmation = await _askForSavingChangesConfirmation();
    if (confirmation) {
      bloc.add(
        FlashcardPreviewEventSaveChanges(),
      );
    }
  }

  Future<bool> _askForSavingChangesConfirmation() async {
    return await DialogsProvider.askForConfirmation(
      title: 'Zapisywanie',
      text: 'Czy na pewno chcesz zapisać zmiany wprowadzone w tej fiszce?',
      confirmButtonText: 'Zapisz',
    );
  }
}
