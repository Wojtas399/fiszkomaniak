import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class FlashcardInfo extends Equatable {
  final int index;
  final String question;
  final String answer;

  const FlashcardInfo({
    required this.index,
    required this.question,
    required this.answer,
  });

  @override
  List<Object> get props => [
        index,
        question,
        answer,
      ];
}

class AnimatedElement extends Equatable {
  final Key key;
  final double scale;
  final double opacity;
  final Position position;
  final FlashcardInfo flashcard;

  const AnimatedElement({
    required this.key,
    required this.scale,
    required this.opacity,
    required this.position,
    required this.flashcard,
  });

  AnimatedElement copyWith({
    Key? key,
    double? scale,
    double? opacity,
    Position? position,
    FlashcardInfo? flashcard,
  }) {
    return AnimatedElement(
      key: key ?? this.key,
      scale: scale ?? this.scale,
      opacity: opacity ?? this.opacity,
      position: position ?? this.position,
      flashcard: flashcard ?? this.flashcard,
    );
  }

  @override
  List<Object> get props => [
        key,
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

FlashcardInfo createFlashcardInfo({
  int? index,
  String? question,
  String? answer,
}) {
  return FlashcardInfo(
    index: index ?? -1,
    question: question ?? '',
    answer: answer ?? '',
  );
}

AnimatedElement createAnimatedElement({
  Key? key,
  double? scale,
  double? opacity,
  Position? position,
  FlashcardInfo? flashcard,
}) {
  return AnimatedElement(
    key: key ?? const ValueKey(''),
    scale: scale ?? 1.0,
    opacity: opacity ?? 1.0,
    position: position ?? createPosition(),
    flashcard: flashcard ?? createFlashcardInfo(),
  );
}

Position createPosition({
  double? left,
  double? right,
  double? top,
  double? bottom,
}) {
  return Position(
    left: left ?? 0,
    right: right ?? 0,
    top: top ?? 0,
    bottom: bottom ?? 0,
  );
}
