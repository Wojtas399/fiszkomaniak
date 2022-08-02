import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../../../components/flashcards_stack/flashcards_stack.dart';
import '../../../providers/theme_provider.dart';
import '../bloc/learning_process_bloc.dart';

class LearningProcessFlashcards extends StatelessWidget {
  const LearningProcessFlashcards({super.key});

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
  const _FlashcardTitle();

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
  const _Side();

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
  const _SideName();

  @override
  Widget build(BuildContext context) {
    final String nameForQuestions =
        context.read<LearningProcessBloc>().state.nameForQuestions;
    final String nameForAnswers =
        context.read<LearningProcessBloc>().state.nameForAnswers;
    final FlashcardsStackStatus flashcardsStackStatus = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.status,
    );
    final ThemeProvider themeProvider = context.read<ThemeProvider>();
    final Color color = themeProvider.isDarkMode
        ? Colors.white.withOpacity(0.6)
        : Colors.black.withOpacity(0.6);
    return Text(
      '(${_getQuestionOrAnswerName(
        flashcardsStackStatus,
        nameForQuestions,
        nameForAnswers,
      )})',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: color,
      ),
    );
  }

  String _getQuestionOrAnswerName(
    FlashcardsStackStatus status,
    String nameForQuestions,
    String nameForAnswers,
  ) {
    if (status is FlashcardsStackStatusAnswer ||
        status is FlashcardsStackStatusAnswerAgain) {
      return nameForAnswers;
    }
    return nameForQuestions;
  }
}
