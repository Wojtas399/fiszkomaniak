import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:fiszkomaniak/features/flashcards_stack/components/flashcards_stack_flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/flashcards_stack_normal_card.dart';

class FlashcardsStack extends StatelessWidget {
  final Curve _curve = Curves.fastOutSlowIn;
  final int _duration = 400;
  final FlipCardController _flipCardController = FlipCardController();

  FlashcardsStack({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardsStackBloc, FlashcardsStackState>(
      builder: (_, FlashcardsStackState state) {
        if (state.status is FlashcardsStackStatusAnswer ||
            (state.status is FlashcardsStackStatusEnd &&
                _flipCardController.state?.isFront == false)) {
          _flipCardController.toggleCard();
        }
        return Stack(
          children: _buildElements(context, state),
        );
      },
    );
  }

  List<Widget> _buildElements(
    BuildContext context,
    FlashcardsStackState state,
  ) {
    return state.animatedElements.reversed
        .toList()
        .asMap()
        .entries
        .map(
          (element) => AnimatedPositioned(
            key: element.value.key,
            left: element.value.position.left,
            right: element.value.position.right,
            top: element.value.position.top,
            bottom: element.value.position.bottom,
            duration: Duration(milliseconds: _duration),
            curve: _curve,
            onEnd: () => _elementAnimationFinished(context, element.key),
            child: AnimatedScale(
              scale: element.value.scale,
              duration: Duration(milliseconds: _duration),
              curve: _curve,
              child: AnimatedOpacity(
                opacity: element.value.opacity,
                duration: Duration(milliseconds: _duration),
                curve: _curve,
                child: element.key == state.animatedElements.length - 1
                    ? FlashcardsStackFlipCard(
                        controller: _flipCardController,
                        question: element.value.flashcard.question,
                        answer: element.value.flashcard.answer,
                        canFlipOnTouch: state.isPreviewProcess,
                        onFlip: state.isPreviewProcess
                            ? () => _flashcardFlipped(context)
                            : null,
                      )
                    : FlashcardsStackNormalCard(
                        text: element.value.flashcard.question,
                      ),
              ),
            ),
          ),
        )
        .toList();
  }

  void _flashcardFlipped(BuildContext context) {
    context
        .read<FlashcardsStackBloc>()
        .add(FlashcardsStackEventFlashcardFlipped());
  }

  void _elementAnimationFinished(BuildContext context, int elementIndex) {
    context
        .read<FlashcardsStackBloc>()
        .add(FlashcardsStackEventElementAnimationFinished(
          elementIndex: elementIndex,
        ));
  }
}
