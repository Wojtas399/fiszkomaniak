import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/flashcards_stack_animated_elements_service.dart';
import 'bloc/flashcards_stack_bloc.dart';
import 'components/flashcards_stack_flip_card.dart';
import 'components/flashcards_stack_normal_card.dart';

const Curve _curve = Curves.fastOutSlowIn;
const Duration _duration = Duration(milliseconds: 400);

class FlashcardsStack extends StatelessWidget {
  final FlipCardController _flipCardController = FlipCardController();

  FlashcardsStack({super.key});

  @override
  Widget build(BuildContext context) {
    final FlashcardsStackStatus status = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.status,
    );
    if (status is FlashcardsStackStatusAnswer ||
        (status is FlashcardsStackStatusEnd &&
            _flipCardController.state?.isFront == false)) {
      _flipCardController.toggleCard();
    }
    return _AnimatedCards(flipCardController: _flipCardController);
  }
}

class _AnimatedCards extends StatelessWidget {
  final FlipCardController flipCardController;

  const _AnimatedCards({required this.flipCardController});

  @override
  Widget build(BuildContext context) {
    final List<AnimatedCard> animatedCards = context.select(
      (FlashcardsStackBloc bloc) => bloc.state.animatedCards,
    );
    return Stack(
      children: animatedCards.reversed
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => _AnimatedPositioned(
              key: ObjectKey(entry.value.flashcard),
              cardIndex: entry.key,
              position: entry.value.position,
              child: _AnimatedScale(
                scale: entry.value.scale,
                child: _AnimatedOpacity(
                  opacity: entry.value.opacity,
                  child: entry.key == animatedCards.length - 1
                      ? FlashcardsStackFlipCard(
                          controller: flipCardController,
                          question: entry.value.flashcard.question,
                          answer: entry.value.flashcard.answer,
                        )
                      : FlashcardsStackNormalCard(
                          text: entry.value.flashcard.question,
                        ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _AnimatedPositioned extends StatelessWidget {
  final int cardIndex;
  final Position position;
  final Widget child;

  const _AnimatedPositioned({
    super.key,
    required this.cardIndex,
    required this.position,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      left: position.left,
      right: position.right,
      top: position.top,
      bottom: position.bottom,
      duration: _duration,
      curve: _curve,
      child: child,
      onEnd: () => _onAnimationEnd(context, cardIndex),
    );
  }

  void _onAnimationEnd(BuildContext context, int elementIndex) {
    context
        .read<FlashcardsStackBloc>()
        .add(FlashcardsStackEventCardAnimationFinished(
          movedCardIndex: elementIndex,
        ));
  }
}

class _AnimatedScale extends StatelessWidget {
  final double scale;
  final Widget child;

  const _AnimatedScale({
    required this.scale,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: scale,
      duration: _duration,
      curve: _curve,
      child: child,
    );
  }
}

class _AnimatedOpacity extends StatelessWidget {
  final double opacity;
  final Widget child;

  const _AnimatedOpacity({
    required this.opacity,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: _duration,
      curve: _curve,
      child: child,
    );
  }
}
