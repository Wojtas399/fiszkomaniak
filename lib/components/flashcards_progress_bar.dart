import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FlashcardsProgressBar extends StatelessWidget {
  final int amountOfRememberedFlashcards;
  final int amountOfAllFlashcards;
  final double barHeight;

  const FlashcardsProgressBar({
    Key? key,
    required this.amountOfRememberedFlashcards,
    required this.amountOfAllFlashcards,
    this.barHeight = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$amountOfRememberedFlashcards/$amountOfAllFlashcards',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 4),
        _ProgressBar(
          amountOfLearnedFlashcards: amountOfRememberedFlashcards,
          amountOfAllFlashcards: amountOfAllFlashcards,
          barHeight: barHeight,
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int amountOfLearnedFlashcards;
  final int amountOfAllFlashcards;
  final double barHeight;

  const _ProgressBar({
    Key? key,
    required this.amountOfLearnedFlashcards,
    required this.amountOfAllFlashcards,
    required this.barHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      height: barHeight,
      decoration: BoxDecoration(
        color: HexColor('#B983FF').withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                right: _countXTranslation(constraints.maxWidth),
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }

  double _countXTranslation(double containerWidth) {
    if (amountOfLearnedFlashcards == 0 && amountOfAllFlashcards == 0) {
      return containerWidth;
    }
    double percentages = amountOfLearnedFlashcards / amountOfAllFlashcards;
    return containerWidth - (containerWidth * percentages);
  }
}
