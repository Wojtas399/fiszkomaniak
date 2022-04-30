import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/flashcards_stack/flashcards_stack.dart';

class LearningProcessFlashcards extends StatelessWidget {
  const LearningProcessFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        children: [
          const _FlashcardTitle(),
          FlashcardsStack(),
        ],
      ),
    );
  }
}

class _FlashcardTitle extends StatelessWidget {
  const _FlashcardTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsStackBloc, FlashcardsStackState>(
      builder: (_, FlashcardsStackState state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Row(
            children: [
              Text(
                _getQuestionOrAnswerText(state.status),
                style: Theme.of(context).textTheme.subtitle1,
              ),
              const SizedBox(width: 4.0),
              Text(
                '(${_getQuestionOrAnswerName(state.status)})',
                style: Theme.of(context).textTheme.bodyText2,
              )
            ],
          ),
        );
      },
    );
  }

  String _getQuestionOrAnswerText(FlashcardsStackStatus status) {
    if (status is FlashcardsStackStatusAnswer ||
        status is FlashcardsStackStatusAnswerAgain) {
      return 'Odpowiedź';
    }
    return 'Pytanie';
  }

  String _getQuestionOrAnswerName(FlashcardsStackStatus status) {
    if (status is FlashcardsStackStatusAnswer) {
      return 'Język polski';
    }
    return 'Język angielski';
  }
}
