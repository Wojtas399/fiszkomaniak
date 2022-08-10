import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/theme/colors.dart';
import '../../../components/buttons/button.dart';
import '../../../components/buttons/small_button.dart';
import '../../../components/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import '../bloc/learning_process_bloc.dart';

class LearningProcessButtons extends StatelessWidget {
  const LearningProcessButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isPreview = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.isPreviewProcess,
    );
    final FlashcardsStackStatus flashcardsStackStatus = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.status,
    );
    if (isPreview) {
      return const _AnswerButtons();
    } else if (flashcardsStackStatus is FlashcardsStackStatusEnd) {
      return const _EndSessionButton();
    }
    return const _QuestionButton();
  }
}

class _QuestionButton extends StatelessWidget {
  const _QuestionButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
      ),
      child: Center(
        child: Button(
          label: 'Pokaż odpowiedź',
          onPressed: () => _showAnswer(context),
        ),
      ),
    );
  }

  void _showAnswer(BuildContext context) {
    context.read<FlashcardsStackBloc>().add(FlashcardsStackEventShowAnswer());
  }
}

class _AnswerButtons extends StatelessWidget {
  const _AnswerButtons();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: SmallButton(
              label: 'Nie udało się',
              color: AppColors.red,
              onPressed: () => _moveLeft(context),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: SmallButton(
              label: 'Udało się',
              color: AppColors.green,
              onPressed: () => _moveRight(context),
            ),
          ),
        ],
      ),
    );
  }

  void _moveLeft(BuildContext context) {
    context.read<FlashcardsStackBloc>().add(FlashcardsStackEventMoveLeft());
  }

  void _moveRight(BuildContext context) {
    context.read<FlashcardsStackBloc>().add(FlashcardsStackEventMoveRight());
  }
}

class _EndSessionButton extends StatelessWidget {
  const _EndSessionButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 24.0,
        right: 24.0,
        bottom: 24.0,
      ),
      child: Center(
        child: Button(
          label: 'Zakończ sesję',
          onPressed: () => _endSession(context),
        ),
      ),
    );
  }

  void _endSession(BuildContext context) {
    context.read<LearningProcessBloc>().add(
          LearningProcessEventSessionFinished(),
        );
  }
}
