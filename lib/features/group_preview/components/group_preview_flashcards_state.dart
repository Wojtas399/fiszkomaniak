import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GroupPreviewFlashcardsState extends StatelessWidget {
  const GroupPreviewFlashcardsState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GroupPreviewBloc, GroupPreviewState>(
      builder: (_, GroupPreviewState state) {
        return Section(
          title: 'Stan fiszek',
          child: Column(
            children: [
              const SizedBox(height: 8.0),
              FlashcardsProgressBar(
                amountOfRememberedFlashcards:
                    state.amountOfRememberedFlashcards,
                amountOfAllFlashcards: state.amountOfAllFlashcards,
                barHeight: 16,
              ),
              const SizedBox(height: 8.0),
              const _FlashcardsOptions(),
            ],
          ),
        );
      },
    );
  }
}

class _FlashcardsOptions extends StatelessWidget {
  const _FlashcardsOptions({Key? key}) : super(key: key);

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
    context.read<GroupPreviewBloc>().add(GroupPreviewEventEditFlashcards());
  }

  void _reviewFlashcards(BuildContext context) {
    context.read<GroupPreviewBloc>().add(GroupPreviewEventReviewFlashcards());
  }
}

class _TextButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _TextButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text, style: const TextStyle(fontSize: 16)),
    );
  }
}
