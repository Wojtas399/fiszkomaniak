import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/flashcards_progress_bar.dart';
import '../bloc/learning_process_bloc.dart';

class LearningProcessProgressBar extends StatelessWidget {
  const LearningProcessProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: _ProgressBar(),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar();

  @override
  Widget build(BuildContext context) {
    final int amountOfRememberedFlashcards = context.select(
      (LearningProcessBloc bloc) => bloc.state.amountOfRememberedFlashcards,
    );
    final int amountOfAllFlashcards = context.select(
      (LearningProcessBloc bloc) => bloc.state.amountOfAllFlashcards,
    );
    return FlashcardsProgressBar(
      amountOfRememberedFlashcards: amountOfRememberedFlashcards,
      amountOfAllFlashcards: amountOfAllFlashcards,
      barHeight: 16,
    );
  }
}
