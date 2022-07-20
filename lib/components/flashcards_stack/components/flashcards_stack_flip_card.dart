import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'flashcards_stack_normal_card.dart';
import '../bloc/flashcards_stack_bloc.dart';

class FlashcardsStackFlipCard extends StatelessWidget {
  final FlipCardController controller;
  final String question;
  final String answer;

  const FlashcardsStackFlipCard({
    super.key,
    required this.controller,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    final bool isPreviewProcess = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.isPreviewProcess,
    );
    return FlipCard(
      controller: controller,
      fill: Fill.fillBack,
      flipOnTouch: isPreviewProcess,
      direction: FlipDirection.HORIZONTAL,
      front: FlashcardsStackNormalCard(text: question),
      back: FlashcardsStackNormalCard(text: answer),
      onFlip: isPreviewProcess ? () => _flashcardFlipped(context) : null,
    );
  }

  void _flashcardFlipped(BuildContext context) {
    context
        .read<FlashcardsStackBloc>()
        .add(FlashcardsStackEventFlashcardFlipped());
  }
}
