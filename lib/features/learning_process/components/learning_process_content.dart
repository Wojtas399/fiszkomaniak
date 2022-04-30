import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/components/flashcards_stack_bloc_provider.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_state.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_buttons.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_flashcards.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_header.dart';
import 'package:fiszkomaniak/features/learning_process/components/learning_process_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../../features/flashcards_stack/bloc/flashcards_stack_status.dart';
import '../../flashcards_stack/bloc/flashcards_stack_models.dart';

class LearningProcessContent extends StatelessWidget {
  const LearningProcessContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (BuildContext context, LearningProcessState state) {
        return FlashcardsStackBlocProvider(
          flashcards: const [
            FlashcardInfo(id: 'f1', question: 'question 1', answer: 'answer 1'),
            FlashcardInfo(id: 'f2', question: 'question 2', answer: 'answer 2'),
            FlashcardInfo(id: 'f3', question: 'question 3', answer: 'answer 3'),
            FlashcardInfo(id: 'f4', question: 'question 4', answer: 'answer 4'),
            FlashcardInfo(id: 'f5', question: 'question 5', answer: 'answer 5'),
            FlashcardInfo(id: 'f6', question: 'question 6', answer: 'answer 6'),
            FlashcardInfo(id: 'f7', question: 'question 7', answer: 'answer 7'),
            FlashcardInfo(id: 'f8', question: 'question 8', answer: 'answer 8'),
            FlashcardInfo(id: 'f9', question: 'question 9', answer: 'answer 9'),
          ],
          child: _FlashcardsStackListener(
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  LearningProcessHeader(),
                  SizedBox(height: 16.0),
                  LearningProcessFlashcards(),
                  SizedBox(height: 8.0),
                  LearningProcessProgressBar(),
                  SizedBox(height: 24.0),
                  LearningProcessButtons(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FlashcardsStackListener extends StatelessWidget {
  final Widget child;

  const _FlashcardsStackListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<FlashcardsStackBloc, FlashcardsStackState>(
      listener: (_, FlashcardsStackState state) {
        final FlashcardsStackStatus status = state.status;
        if (status is FlashcardsStackStatusMovedLeft) {
          //TODO
        } else if (status is FlashcardsStackStatusMovedRight) {
          //TODO
        }
      },
      child: child,
    );
  }
}
