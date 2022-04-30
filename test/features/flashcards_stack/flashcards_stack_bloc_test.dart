import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_event.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_models.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_state.dart';
import 'package:fiszkomaniak/features/flashcards_stack/bloc/flashcards_stack_status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsStackBloc bloc;
  final List<FlashcardInfo> flashcards = [
    createFlashcardInfo(id: 'f1', question: 'q1', answer: 'a1'),
    createFlashcardInfo(id: 'f2', question: 'g2', answer: 'a2'),
    createFlashcardInfo(id: 'f3', question: 'q3', answer: 'a3'),
    createFlashcardInfo(id: 'f4', question: 'q4', answer: 'a4'),
    createFlashcardInfo(id: 'f5', question: 'q5', answer: 'a5'),
    createFlashcardInfo(id: 'f6', question: 'q6', answer: 'a6'),
  ];
  final List<AnimatedElement> initialElements = [
    AnimatedElement(
      key: const ValueKey('flashcard0'),
      scale: 1.0,
      opacity: 1.0,
      position: const Position(
        left: 24.0,
        right: 24.0,
        top: 30.0,
        bottom: 30.0,
      ),
      flashcard: flashcards[0],
    ),
    AnimatedElement(
      key: const ValueKey('flashcard1'),
      scale: 0.98,
      opacity: 1.0,
      position: const Position(
        left: 24.0,
        right: 24.0,
        top: 45.0,
        bottom: 15.0,
      ),
      flashcard: flashcards[1],
    ),
    AnimatedElement(
      key: const ValueKey('flashcard2'),
      scale: 0.96,
      opacity: 1.0,
      position: const Position(
        left: 24.0,
        right: 24.0,
        top: 60.0,
        bottom: 0.0,
      ),
      flashcard: flashcards[2],
    ),
    AnimatedElement(
      key: const ValueKey('flashcard3'),
      scale: 0.94,
      opacity: 0.0,
      position: const Position(
        left: 24.0,
        right: 24.0,
        top: 75.0,
        bottom: -15.0,
      ),
      flashcard: flashcards[3],
    ),
    AnimatedElement(
      key: const ValueKey('flashcard4'),
      scale: 1.0,
      opacity: 0.0,
      position: const Position(
        left: 424.0,
        right: -376.0,
        top: 30.0,
        bottom: 30.0,
      ),
      flashcard: flashcards[4],
    ),
  ];

  setUp(() {
    bloc = FlashcardsStackBloc();
  });

  blocTest(
    'initialize, flashcards amount higher than 4 elements',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardsStackEventInitialize(flashcards: flashcards),
    ),
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: initialElements,
      ),
    ],
  );

  blocTest(
    'initialize, flashcards amount lower than 4 elements',
    build: () => bloc,
    act: (_) => bloc.add(
      FlashcardsStackEventInitialize(
        flashcards: flashcards.getRange(0, 3).toList(),
      ),
    ),
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 3).toList(),
        animatedElements: initialElements.getRange(0, 3).toList(),
      ),
    ],
  );

  blocTest(
    'show answer',
    build: () => bloc,
    act: (_) => bloc.add(FlashcardsStackEventShowAnswer()),
    expect: () => [
      const FlashcardsStackState(status: FlashcardsStackStatusAnswer()),
    ],
  );

  blocTest(
    'move left',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(flashcards: flashcards));
      bloc.add(FlashcardsStackEventMoveLeft());
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: initialElements,
      ),
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: -376.0,
                  right: 424.0,
                ),
          ),
          initialElements[1].copyWith(
            scale: 1.0,
            position: initialElements[1].position.copyWith(
                  top: 30.0,
                  bottom: 30.0,
                ),
          ),
          initialElements[2].copyWith(
            scale: 0.98,
            position: initialElements[2].position.copyWith(
                  top: 45.0,
                  bottom: 15.0,
                ),
          ),
          initialElements[3].copyWith(
            opacity: 1.0,
            scale: 0.96,
            position: initialElements[3].position.copyWith(
                  top: 60.0,
                  bottom: 0.0,
                ),
          ),
          initialElements[4].copyWith(
            opacity: 0.0,
            scale: 0.94,
            position: initialElements[4].position.copyWith(
                  left: 24.0,
                  right: 24.0,
                  top: 75.0,
                  bottom: -15.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusMovedLeft(
          flashcardId: initialElements[0].flashcard.id,
        ),
      ),
    ],
  );

  blocTest(
    'move right',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(flashcards: flashcards));
      bloc.add(FlashcardsStackEventMoveRight());
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: initialElements,
      ),
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
          initialElements[1].copyWith(
            scale: 1.0,
            position: initialElements[1].position.copyWith(
                  top: 30.0,
                  bottom: 30.0,
                ),
          ),
          initialElements[2].copyWith(
            scale: 0.98,
            position: initialElements[2].position.copyWith(
                  top: 45.0,
                  bottom: 15.0,
                ),
          ),
          initialElements[3].copyWith(
            opacity: 1.0,
            scale: 0.96,
            position: initialElements[3].position.copyWith(
                  top: 60.0,
                  bottom: 0.0,
                ),
          ),
          initialElements[4].copyWith(
            opacity: 0.0,
            scale: 0.94,
            position: initialElements[4].position.copyWith(
                  left: 24.0,
                  right: 24.0,
                  top: 75.0,
                  bottom: -15.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusMovedRight(
          flashcardId: initialElements[0].flashcard.id,
        ),
      ),
    ],
  );

  blocTest(
    'animation finished, last flashcard',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(
        flashcards: flashcards.getRange(0, 1).toList(),
      ));
      bloc.add(FlashcardsStackEventMoveRight());
      bloc.add(FlashcardsStackEventElementAnimationFinished(elementIndex: 0));
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: initialElements.getRange(0, 1).toList(),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusMovedRight(
          flashcardId: initialElements[0].flashcard.id,
        ),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusEnd(),
      ),
    ],
  );

  blocTest(
    'animation finished, first animated element',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(flashcards: flashcards));
      bloc.add(FlashcardsStackEventMoveRight());
      bloc.add(FlashcardsStackEventElementAnimationFinished(elementIndex: 0));
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: initialElements,
      ),
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
          initialElements[1].copyWith(
            scale: 1.0,
            position: initialElements[1].position.copyWith(
                  top: 30.0,
                  bottom: 30.0,
                ),
          ),
          initialElements[2].copyWith(
            scale: 0.98,
            position: initialElements[2].position.copyWith(
                  top: 45.0,
                  bottom: 15.0,
                ),
          ),
          initialElements[3].copyWith(
            opacity: 1.0,
            scale: 0.96,
            position: initialElements[3].position.copyWith(
                  top: 60.0,
                  bottom: 0.0,
                ),
          ),
          initialElements[4].copyWith(
            opacity: 0.0,
            scale: 0.94,
            position: initialElements[4].position.copyWith(
                  left: 24.0,
                  right: 24.0,
                  top: 75.0,
                  bottom: -15.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusMovedRight(
          flashcardId: initialElements[0].flashcard.id,
        ),
      ),
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: [
          initialElements[1].copyWith(
            scale: 1.0,
            position: initialElements[1].position.copyWith(
                  top: 30.0,
                  bottom: 30.0,
                ),
          ),
          initialElements[2].copyWith(
            scale: 0.98,
            position: initialElements[2].position.copyWith(
                  top: 45.0,
                  bottom: 15.0,
                ),
          ),
          initialElements[3].copyWith(
            opacity: 1.0,
            scale: 0.96,
            position: initialElements[3].position.copyWith(
                  top: 60.0,
                  bottom: 0.0,
                ),
          ),
          initialElements[4].copyWith(
            opacity: 0.0,
            scale: 0.94,
            position: initialElements[4].position.copyWith(
                  left: 24.0,
                  right: 24.0,
                  top: 75.0,
                  bottom: -15.0,
                ),
          ),
          initialElements[0].copyWith(
            opacity: 0.0,
            flashcard: flashcards[5],
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: const FlashcardsStackStatusQuestion(),
      ),
    ],
  );

  blocTest(
    'animation finished, not first animated element',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(flashcards: flashcards));
      bloc.add(FlashcardsStackEventMoveRight());
      bloc.add(FlashcardsStackEventElementAnimationFinished(elementIndex: 1));
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: initialElements,
      ),
      FlashcardsStackState(
        flashcards: flashcards,
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
          initialElements[1].copyWith(
            scale: 1.0,
            position: initialElements[1].position.copyWith(
                  top: 30.0,
                  bottom: 30.0,
                ),
          ),
          initialElements[2].copyWith(
            scale: 0.98,
            position: initialElements[2].position.copyWith(
                  top: 45.0,
                  bottom: 15.0,
                ),
          ),
          initialElements[3].copyWith(
            opacity: 1.0,
            scale: 0.96,
            position: initialElements[3].position.copyWith(
                  top: 60.0,
                  bottom: 0.0,
                ),
          ),
          initialElements[4].copyWith(
            opacity: 0.0,
            scale: 0.94,
            position: initialElements[4].position.copyWith(
                  left: 24.0,
                  right: 24.0,
                  top: 75.0,
                  bottom: -15.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusMovedRight(
          flashcardId: initialElements[0].flashcard.id,
        ),
      ),
    ],
  );

  blocTest(
    'flashcard flipped',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(
        flashcards: flashcards.getRange(0, 1).toList(),
      ));
      bloc.add(FlashcardsStackEventShowAnswer());
      bloc.add(FlashcardsStackEventFlashcardFlipped());
      bloc.add(FlashcardsStackEventFlashcardFlipped());
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: initialElements.getRange(0, 1).toList(),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: initialElements.getRange(0, 1).toList(),
        status: const FlashcardsStackStatusAnswer(),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: initialElements.getRange(0, 1).toList(),
        status: FlashcardsStackStatusQuestionAgain(),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 1).toList(),
        animatedElements: initialElements.getRange(0, 1).toList(),
        status: FlashcardsStackStatusAnswerAgain(),
      ),
    ],
  );

  blocTest(
    'reset',
    build: () => bloc,
    act: (_) {
      bloc.add(FlashcardsStackEventInitialize(
        flashcards: flashcards.getRange(0, 2).toList(),
      ));
      bloc.add(FlashcardsStackEventMoveRight());
      bloc.add(FlashcardsStackEventReset());
    },
    expect: () => [
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 2).toList(),
        animatedElements: initialElements.getRange(0, 2).toList(),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 2).toList(),
        animatedElements: [
          initialElements[0].copyWith(
            position: initialElements[0].position.copyWith(
                  left: 424.0,
                  right: -376.0,
                ),
          ),
          initialElements[1].copyWith(
            scale: 1.0,
            position: initialElements[1].position.copyWith(
                  top: 30.0,
                  bottom: 30.0,
                ),
          ),
        ],
        indexOfDisplayedFlashcard: 1,
        status: FlashcardsStackStatusMovedRight(
          flashcardId: initialElements[0].flashcard.id,
        ),
      ),
      FlashcardsStackState(
        flashcards: flashcards.getRange(0, 2).toList(),
        animatedElements: initialElements.getRange(0, 2).toList(),
      ),
    ],
  );
}
