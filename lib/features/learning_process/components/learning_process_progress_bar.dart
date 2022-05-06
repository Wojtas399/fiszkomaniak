import 'package:fiszkomaniak/components/flashcards_progress_bar.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LearningProcessProgressBar extends StatelessWidget {
  const LearningProcessProgressBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (BuildContext context, LearningProcessState state) {
        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: FlashcardsProgressBar(
              amountOfRememberedFlashcards: state.amountOfRememberedFlashcards,
              amountOfAllFlashcards: state.amountOfAllFlashcards,
              barHeight: 16,
            ),
          ),
        );
      },
    );
  }
}
