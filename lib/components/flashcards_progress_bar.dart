import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class FlashcardsProgressBar extends StatelessWidget {
  final int amountOfLearnedFlashcards;
  final int amountOfAllFlashcards;

  const FlashcardsProgressBar({
    Key? key,
    required this.amountOfLearnedFlashcards,
    required this.amountOfAllFlashcards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$amountOfLearnedFlashcards/$amountOfAllFlashcards',
          style: Theme.of(context).textTheme.bodyText2,
        ),
        const SizedBox(height: 4),
        _ProgressBar(
          amountOfLearnedFlashcards: amountOfLearnedFlashcards,
          amountOfAllFlashcards: amountOfAllFlashcards,
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  final int amountOfLearnedFlashcards;
  final int amountOfAllFlashcards;

  const _ProgressBar({
    Key? key,
    required this.amountOfLearnedFlashcards,
    required this.amountOfAllFlashcards,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.hardEdge,
      height: 10,
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
    double percentages = amountOfLearnedFlashcards / amountOfAllFlashcards;
    return containerWidth - (containerWidth * percentages);
  }
}
