import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:flutter/material.dart';

class GroupPreviewFlashcardsState extends StatelessWidget {
  final String groupId;

  const GroupPreviewFlashcardsState({Key? key, required this.groupId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Stan',
      child: Column(
        children: const [
          SizedBox(height: 8),
          FlashcardsProgressBar(
            amountOfLearnedFlashcards: 250,
            amountOfAllFlashcards: 500,
            barHeight: 16,
          )
        ],
      ),
    );
  }
}
