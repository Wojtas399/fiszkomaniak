import 'package:equatable/equatable.dart';
import '../flashcards_stack_model.dart';

const _amountOfCardsInStack = 5;
const _indexOfLastCardInStack = _amountOfCardsInStack - 1;
const List<double> _scaleSteps = [1.0, 0.98, 0.96, 0.94];
const List<double> _bottomSteps = [60.0, 45.0, 30.0, 15.0];
const List<double> _topSteps = [30.0, 45.0, 60.0, 75.0];

mixin FlashcardsStackAnimatedCardsService {
  List<AnimatedCard> getInitialAnimatedCards(List<StackFlashcard> flashcards) {
    final List<AnimatedCard> cards = [];
    final int maxIndex = flashcards.length < _amountOfCardsInStack
        ? flashcards.length - 1
        : _indexOfLastCardInStack;
    for (int i = 0; i <= maxIndex; i++) {
      cards.add(_createCard(i, flashcards[i]));
    }
    return cards;
  }

  List<AnimatedCard> moveCards(
    List<AnimatedCard> cards,
    Direction direction,
    bool areThereUndisplayedFlashcards,
  ) {
    final List<AnimatedCard> updatedCards = [...cards];
    final AnimatedCard movedCard = updatedCards.first.copyWith(
      position: _getNewPositionDependingOnMovementDirection(
        direction,
        updatedCards.first.position,
      ),
    );
    final List<AnimatedCard> cardsUnderMovedCard = _updateCardsUnderMovedCard(
      cards.getRange(1, cards.length).toList(),
      areThereUndisplayedFlashcards,
    );
    return [movedCard, ...cardsUnderMovedCard];
  }

  List<AnimatedCard> moveFirstCardToTheEnd(List<AnimatedCard> cards) {
    return [
      ...cards.getRange(1, cards.length),
      cards.first.copyWith(opacity: 0),
    ];
  }

  AnimatedCard _createCard(int index, StackFlashcard flashcard) {
    final bool isCardLastInStack = index == _indexOfLastCardInStack;
    final bool isCardNextToLastInStack = index == _indexOfLastCardInStack - 1;
    return AnimatedCard(
      opacity: isCardLastInStack || isCardNextToLastInStack ? 0.0 : 1.0,
      scale: isCardLastInStack ? 1.0 : _scaleSteps[index],
      position: Position(
        left: isCardLastInStack ? 424.0 : 24.0,
        right: isCardLastInStack ? -376.0 : 24.0,
        top: _topSteps[isCardLastInStack ? 0 : index],
        bottom: _bottomSteps[isCardLastInStack ? 0 : index],
      ),
      flashcard: flashcard,
    );
  }

  Position _getNewPositionDependingOnMovementDirection(
    Direction direction,
    Position elementPosition,
  ) {
    switch (direction) {
      case Direction.left:
        return elementPosition.copyWith(
          left: elementPosition.left - 400,
          right: elementPosition.right + 400,
        );
      case Direction.right:
        return elementPosition.copyWith(
          left: elementPosition.left + 400,
          right: elementPosition.right - 400,
        );
    }
  }

  List<AnimatedCard> _updateCardsUnderMovedCard(
    List<AnimatedCard> cards,
    bool areThereUndisplayedFlashcards,
  ) {
    final List<AnimatedCard> updatedCards = [...cards];
    for (int i = 0; i < updatedCards.length; i++) {
      double? left, right;
      if (i == updatedCards.length - 1 && areThereUndisplayedFlashcards) {
        left = 24.0;
        right = 24.0;
      }
      final AnimatedCard card = updatedCards[i];
      updatedCards[i] = card.copyWith(
        opacity: i == updatedCards.length - 1 && updatedCards.length >= 3
            ? 0.0
            : 1.0,
        scale: _scaleSteps[i],
        position: card.position.copyWith(
          top: _topSteps[i],
          bottom: _bottomSteps[i],
          left: left,
          right: right,
        ),
      );
    }
    return updatedCards;
  }
}

enum Direction { left, right }

class AnimatedCard extends Equatable {
  final double scale;
  final double opacity;
  final Position position;
  final StackFlashcard flashcard;

  const AnimatedCard({
    required this.scale,
    required this.opacity,
    required this.position,
    required this.flashcard,
  });

  AnimatedCard copyWith({
    double? scale,
    double? opacity,
    Position? position,
    StackFlashcard? flashcard,
  }) {
    return AnimatedCard(
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      position: position ?? this.position,
      flashcard: flashcard ?? this.flashcard,
    );
  }

  @override
  List<Object> get props => [
        scale,
        opacity,
        position,
        flashcard,
      ];
}

class Position extends Equatable {
  final double left;
  final double right;
  final double top;
  final double bottom;

  const Position({
    required this.left,
    required this.right,
    required this.top,
    required this.bottom,
  });

  Position copyWith({
    double? left,
    double? right,
    double? top,
    double? bottom,
  }) {
    return Position(
      left: left ?? this.left,
      right: right ?? this.right,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
    );
  }

  @override
  List<Object> get props => [
        left,
        right,
        top,
        bottom,
      ];
}
