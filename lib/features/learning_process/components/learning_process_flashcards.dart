import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:fiszkomaniak/features/learning_process/bloc/learning_process_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../features/flashcards_stack/flashcards_stack.dart';

class LearningProcessFlashcards extends StatelessWidget {
  const LearningProcessFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0.0,
      bottom: 16.0,
      left: 0.0,
      right: 0.0,
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
    return Positioned(
      left: 24.0,
      right: 24.0,
      child: Row(
        children: const [
          _Side(),
          SizedBox(width: 4.0),
          Expanded(child: _SideName()),
        ],
      ),
    );
  }
}

class _Side extends StatelessWidget {
  const _Side({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FlashcardsStackStatus status = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.status,
    );
    return Text(
      _getQuestionOrAnswerText(status),
      style: Theme.of(context).textTheme.subtitle1,
    );
  }

  String _getQuestionOrAnswerText(FlashcardsStackStatus status) {
    if (status is FlashcardsStackStatusAnswer ||
        status is FlashcardsStackStatusAnswerAgain) {
      return 'Odpowiedź';
    }
    return 'Pytanie';
  }
}

class _SideName extends StatelessWidget {
  const _SideName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LearningProcessBloc, LearningProcessState>(
      builder: (
        BuildContext context,
        LearningProcessState learningProcessState,
      ) {
        final FlashcardsStackStatus flashcardsStackStatus = context.select(
          (FlashcardsStackBloc bloc) => bloc.state.status,
        );
        return Text(
          '(${_getQuestionOrAnswerName(
            flashcardsStackStatus,
            learningProcessState.nameForQuestions,
            learningProcessState.nameForAnswers,
          )})',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black.withOpacity(0.6),
          ),
        );
      },
    );
  }

  String _getQuestionOrAnswerName(
    FlashcardsStackStatus status,
    String nameForQuestions,
    String nameForAnswers,
  ) {
    if (status is FlashcardsStackStatusAnswer) {
      return nameForAnswers;
    }
    return nameForQuestions;
  }
}
