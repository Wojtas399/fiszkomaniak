import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/flashcards_progress_bar.dart';
import '../../../components/item_with_icon.dart';
import '../bloc/group_selection_bloc.dart';

class GroupSelectionFlashcardsInfo extends StatelessWidget {
  const GroupSelectionFlashcardsInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _NameForQuestions(),
        _NameForAnswers(),
        Padding(
          padding: EdgeInsets.only(top: 24.0, left: 8.0, right: 8.0),
          child: _FlashcardsProgressBar(),
        ),
      ],
    );
  }
}

class _NameForQuestions extends StatelessWidget {
  const _NameForQuestions();

  @override
  Widget build(BuildContext context) {
    final String? nameForQuestions = context.select(
      (GroupSelectionBloc bloc) => bloc.state.selectedGroup?.nameForQuestions,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileOutline,
      label: 'Nazwa dla pytań',
      text: nameForQuestions ?? '--',
      paddingLeft: 8,
      paddingRight: 8,
    );
  }
}

class _NameForAnswers extends StatelessWidget {
  const _NameForAnswers();

  @override
  Widget build(BuildContext context) {
    final String? nameForAnswers = context.select(
      (GroupSelectionBloc bloc) => bloc.state.selectedGroup?.nameForAnswers,
    );
    return ItemWithIcon(
      icon: MdiIcons.fileReplaceOutline,
      label: 'Nazwa dla odpowiedzi',
      text: nameForAnswers ?? '--',
      paddingLeft: 8,
      paddingRight: 8,
    );
  }
}

class _FlashcardsProgressBar extends StatelessWidget {
  const _FlashcardsProgressBar();

  @override
  Widget build(BuildContext context) {
    final int amountOfRememberedFlashcards = context.select(
      (GroupSelectionBloc bloc) => bloc.state.amountOfRememberedFlashcards,
    );
    final int amountOfAllFlashcards = context.select(
      (GroupSelectionBloc bloc) => bloc.state.amountOfAllFlashcards,
    );
    return FlashcardsProgressBar(
      amountOfRememberedFlashcards: amountOfRememberedFlashcards,
      amountOfAllFlashcards: amountOfAllFlashcards,
      barHeight: 16,
    );
  }
}
