import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:flutter/material.dart';

class LearningProcessProgressBar extends StatelessWidget {
  const LearningProcessProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: FlashcardsProgressBar(
        amountOfRememberedFlashcards: 190,
        amountOfAllFlashcards: 400,
        barHeight: 16,
      ),
    );
  }
}
