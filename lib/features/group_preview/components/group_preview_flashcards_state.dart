import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPreviewFlashcardsState extends StatelessWidget {
  const GroupPreviewFlashcardsState({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 8.0);
    return Section(
      title: 'Stan fiszek',
      child: Column(
        children: const [
          gap,
          _FlashcardsProgressBar(),
          gap,
          _FlashcardsOptions(),
        ],
      ),
    );
  }
}

class _FlashcardsProgressBar extends StatelessWidget {
  const _FlashcardsProgressBar();

  @override
  Widget build(BuildContext context) {
    final int amountOfAllFlashcards = context.select(
      (GroupPreviewBloc bloc) => bloc.state.amountOfAllFlashcards,
    );
    final int amountOfRememberedFlashcards = context.select(
      (GroupPreviewBloc bloc) => bloc.state.amountOfRememberedFlashcards,
    );
    return FlashcardsProgressBar(
      amountOfRememberedFlashcards: amountOfRememberedFlashcards,
      amountOfAllFlashcards: amountOfAllFlashcards,
    );
  }
}

class _FlashcardsOptions extends StatelessWidget {
  const _FlashcardsOptions();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _TextButton(
            text: 'Edytuj',
            onPressed: () => _editFlashcards(context),
          ),
        ),
        Expanded(
          child: _TextButton(
            text: 'Przeglądaj',
            onPressed: () => _reviewFlashcards(context),
          ),
        ),
      ],
    );
  }

  void _editFlashcards(BuildContext context) {
    final String? groupId = context.read<GroupPreviewBloc>().state.group?.id;
    if (groupId != null) {
      Navigation.navigateToFlashcardsEditor(groupId);
    }
  }

  void _reviewFlashcards(BuildContext context) {
    final String? groupId = context.read<GroupPreviewBloc>().state.group?.id;
    if (groupId != null) {
      Navigation.navigateToGroupFlashcardsPreview(groupId);
    }
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _TextButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
