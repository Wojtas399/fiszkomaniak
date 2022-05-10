import 'package:fiszkomaniak/components/buttons/button.dart';
import 'package:fiszkomaniak/config/theme/colors.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../components/buttons/small_button.dart';
import '../bloc/learning_process_bloc.dart';

class LearningProcessButtons extends StatelessWidget {
  const LearningProcessButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsStackBloc, FlashcardsStackState>(
      builder: (_, FlashcardsStackState state) {
        if (state.isPreviewProcess) {
          return const _AnswerButtons();
        } else if (state.status is FlashcardsStackStatusEnd) {
          return const _EndSessionButton();
        }
        return const _QuestionButton();
      },
    );
  }
}

class _QuestionButton extends StatelessWidget {
  const _QuestionButton({Key? key}) : super(key: key);

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
  const _AnswerButtons({Key? key}) : super(key: key);

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
  const _EndSessionButton({Key? key}) : super(key: key);

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
    context.read<LearningProcessBloc>().add(LearningProcessEventEndSession());
  }
}
