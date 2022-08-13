import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/custom_icon_button.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/flashcards_type_picker.dart';
import '../../../domain/entities/session.dart';
import '../bloc/session_preview_bloc.dart';
import '../bloc/session_preview_mode.dart';

class SessionPreviewFlashcards extends StatelessWidget {
  const SessionPreviewFlashcards({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: const [
            _FlashcardsTypeSelection(),
            _NameForQuestions(),
            _NameForAnswers(),
          ],
        ),
        const _QuestionsAndAnswersSwapButton(),
      ],
    );
  }
}

class _FlashcardsTypeSelection extends StatelessWidget {
  const _FlashcardsTypeSelection();

  @override
  Widget build(BuildContext context) {
    final FlashcardsType flashcardsType = context.select(
      (SessionPreviewBloc bloc) => bloc.state.flashcardsType,
    );
    final List<FlashcardsType> availableFlashcardsTypes = context.select(
      (SessionPreviewBloc bloc) => bloc.state.availableFlashcardsTypes,
    );
    final SessionPreviewMode? mode = context.select(
      (SessionPreviewBloc bloc) => bloc.state.mode,
    );
    return FlashcardsTypePicker(
      selectedType: flashcardsType,
      availableTypes: availableFlashcardsTypes,
      onTypeChanged: mode is SessionPreviewModeQuick
          ? (FlashcardsType type) => _onFlashcardsTypeChanged(
                context,
                type,
              )
          : null,
    );
  }

  void _onFlashcardsTypeChanged(BuildContext context, FlashcardsType type) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventFlashcardsTypeChanged(flashcardsType: type));
  }
}

class _NameForQuestions extends StatelessWidget {
  const _NameForQuestions();

  @override
  Widget build(BuildContext context) {
    final String? nameForQuestions = context.select(
      (SessionPreviewBloc bloc) => bloc.state.nameForQuestions,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileOutline,
      label: 'Pytania',
      text: nameForQuestions ?? '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
    );
  }
}

class _NameForAnswers extends StatelessWidget {
  const _NameForAnswers();

  @override
  Widget build(BuildContext context) {
    final String? nameForAnswers = context.select(
      (SessionPreviewBloc bloc) => bloc.state.nameForAnswers,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileReplaceOutline,
      label: 'Odpowiedzi',
      text: nameForAnswers ?? '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
    );
  }
}

class _QuestionsAndAnswersSwapButton extends StatelessWidget {
  const _QuestionsAndAnswersSwapButton();

  @override
  Widget build(BuildContext context) {
    final SessionPreviewMode? mode = context.select(
      (SessionPreviewBloc bloc) => bloc.state.mode,
    );
    return mode is SessionPreviewModeQuick
        ? Positioned(
            right: 0.0,
            bottom: 42.0,
            child: CustomIconButton(
              icon: MdiIcons.swapVertical,
              onPressed: () => _swapQuestionsAndAnswers(context),
            ),
          )
        : const SizedBox();
  }

  void _swapQuestionsAndAnswers(BuildContext context) {
    context
        .read<SessionPreviewBloc>()
        .add(SessionPreviewEventSwapQuestionsAndAnswers());
  }
}
