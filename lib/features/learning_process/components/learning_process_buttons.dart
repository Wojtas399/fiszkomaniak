import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

class LearningProcessButtons extends StatelessWidget {
  const LearningProcessButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsStackBloc, FlashcardsStackState>(
      builder: (_, FlashcardsStackState state) {
        if (state.isPreviewProcess) {
          return const _AnswerButtons();
        }
        return _QuestionButton(
          isDisabled: state.status is FlashcardsStackStatusEnd,
        );
      },
    );
  }
}

class _QuestionButton extends StatelessWidget {
  final bool isDisabled;

  const _QuestionButton({
    Key? key,
    required this.isDisabled,
  }) : super(key: key);

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
          onPressed: isDisabled ? null : () => _showAnswer(context),
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
            child: _SmallButton(
              text: 'Nie udało się',
              color: HexColor('#FF6961'),
              onPressed: () => _moveLeft(context),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: _SmallButton(
              text: 'Udało się',
              color: HexColor('#63B76C'),
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

class _SmallButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _SmallButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 51,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          ),
        ),
      ),
    );
  }
}
