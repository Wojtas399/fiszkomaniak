import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'flashcards_stack_normal_card.dart';

class FlashcardsStackFlipCard extends StatelessWidget {
  final FlipCardController controller;
  final String question;
  final String answer;
  final bool canFlipOnTouch;
  final VoidCallback? onFlip;

  const FlashcardsStackFlipCard({
    Key? key,
    required this.controller,
    required this.question,
    required this.answer,
    this.canFlipOnTouch = false,
    this.onFlip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      controller: controller,
      fill: Fill.fillBack,
      flipOnTouch: canFlipOnTouch,
      direction: FlipDirection.HORIZONTAL,
      front: FlashcardsStackNormalCard(text: question),
      back: FlashcardsStackNormalCard(text: answer),
      onFlip: onFlip,
    );
  }
}
