import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final FlashcardsEditorUtils utils = FlashcardsEditorUtils();
  final List<Flashcard> initialFlashcards = [
    createFlashcard(id: 'f1', question: 'question 1', answer: 'answer 1'),
    createFlashcard(id: 'f2', question: 'question 2', answer: 'answer 2'),
    createFlashcard(id: 'f3', question: 'question 3', answer: 'answer 3'),
  ];

  group('remove unused flashcards without the last one', () {
    test('some flashcards are empty', () {
      final List<EditorFlashcard> editedFlashcards = [
        createEditorFlashcard(doc: initialFlashcards[0]),
        createEditorFlashcard(
          doc: initialFlashcards[1].copyWith(question: '', answer: ''),
        ),
        createEditorFlashcard(
          doc: initialFlashcards[2].copyWith(question: '', answer: ''),
        ),
        createEditorFlashcard(doc: createFlashcard()),
        createEditorFlashcard(doc: createFlashcard()),
      ];

      final List<EditorFlashcard> updatedFlashcards =
          utils.removeEmptyFlashcardsWithoutLastOneAndChangedFlashcard(
        editedFlashcards,
        1,
      );

      expect(updatedFlashcards, [
        editedFlashcards[0],
        editedFlashcards[1],
        editedFlashcards[4],
      ]);
    });

    test('all flashcards are completed', () {
      final List<EditorFlashcard> editedFlashcards = [
        createEditorFlashcard(doc: initialFlashcards[0]),
        createEditorFlashcard(doc: initialFlashcards[1]),
        createEditorFlashcard(doc: initialFlashcards[2]),
      ];

      final List<EditorFlashcard> updatedFlashcards =
          utils.removeEmptyFlashcardsWithoutLastOneAndChangedFlashcard(
        editedFlashcards,
        1,
      );

      expect(updatedFlashcards, editedFlashcards);
    });
  });

  test('set flashcards as correct if it is possible', () {
    final List<EditorFlashcard> editedFlashcards = [
      createEditorFlashcard(isCorrect: false, doc: initialFlashcards[0]),
      createEditorFlashcard(isCorrect: true, doc: initialFlashcards[1]),
      createEditorFlashcard(
        isCorrect: false,
        doc: initialFlashcards[2].copyWith(answer: ''),
      ),
    ];

    final List<EditorFlashcard> updatedFlashcards =
        utils.setFlashcardsAsCorrectIfItIsPossible(editedFlashcards);

    expect(updatedFlashcards, [
      createEditorFlashcard(isCorrect: true, doc: initialFlashcards[0]),
      createEditorFlashcard(isCorrect: true, doc: initialFlashcards[1]),
      createEditorFlashcard(
        isCorrect: false,
        doc: initialFlashcards[2].copyWith(answer: ''),
      ),
    ]);
  });

  group('group flashcards into appropriate groups', () {
    test('new flashcard', () {
      final Flashcard newFlashcard = createFlashcard(
        question: 'q4',
        answer: 'a4',
      );
      final List<Flashcard> editedFlashcards = [
        ...initialFlashcards,
        newFlashcard,
      ];

      final FlashcardsEditorGroups groups =
          utils.groupFlashcardsIntoAppropriateGroups(
        editedFlashcards,
        initialFlashcards,
      );

      expect(groups.added, [newFlashcard]);
      expect(groups.edited, []);
      expect(groups.removed, []);
    });

    test('new empty flashcard', () {
      final List<Flashcard> editedFlashcards = [
        ...initialFlashcards,
        createFlashcard(),
      ];

      final FlashcardsEditorGroups groups =
          utils.groupFlashcardsIntoAppropriateGroups(
        editedFlashcards,
        initialFlashcards,
      );

      expect(groups.added, []);
      expect(groups.edited, []);
      expect(groups.removed, []);
    });

    test('edited flashcard', () {
      final Flashcard editedFlashcard = initialFlashcards[1].copyWith(
        answer: 'a2',
      );
      final List<Flashcard> editedFlashcards = [
        initialFlashcards[0],
        editedFlashcard,
        initialFlashcards[2],
      ];

      final FlashcardsEditorGroups groups =
          utils.groupFlashcardsIntoAppropriateGroups(
        editedFlashcards,
        initialFlashcards,
      );

      expect(groups.added, []);
      expect(groups.edited, [editedFlashcard]);
      expect(groups.removed, []);
    });

    test('edited empty flashcard', () {
      final Flashcard editedFlashcard = initialFlashcards[1].copyWith(
        answer: '',
        question: '',
      );
      final List<Flashcard> editedFlashcards = [
        initialFlashcards[0],
        editedFlashcard,
        initialFlashcards[2],
      ];

      final FlashcardsEditorGroups groups =
          utils.groupFlashcardsIntoAppropriateGroups(
        editedFlashcards,
        initialFlashcards,
      );

      expect(groups.added, []);
      expect(groups.edited, []);
      expect(groups.removed, [editedFlashcard.id]);
    });

    test('removed flashcard', () {
      final List<Flashcard> editedFlashcards = [
        initialFlashcards[0],
        initialFlashcards[2],
      ];

      final FlashcardsEditorGroups groups =
          utils.groupFlashcardsIntoAppropriateGroups(
        editedFlashcards,
        initialFlashcards,
      );

      expect(groups.added, []);
      expect(groups.edited, []);
      expect(groups.removed, [initialFlashcards[1].id]);
    });
  });

  group('look for incorrectly completed flashcards', () {
    test('some flashcards are not fully completed', () {
      final List<Flashcard> editedFlashcards = [
        initialFlashcards[0],
        initialFlashcards[1].copyWith(question: ''),
        initialFlashcards[2].copyWith(answer: ''),
      ];

      final List<Flashcard> incorrectFlashcards =
          utils.lookForIncorrectlyCompletedFlashcards(editedFlashcards);

      expect(incorrectFlashcards, [
        editedFlashcards[1],
        editedFlashcards[2],
      ]);
    });

    test('all flashcards are fully completed', () {
      final List<Flashcard> incorrectFlashcards =
          utils.lookForIncorrectlyCompletedFlashcards(initialFlashcards);

      expect(incorrectFlashcards, []);
    });
  });

  group('look for duplicates', () {
    test('there is some duplicates', () {
      final List<Flashcard> editedFlashcards = [
        ...initialFlashcards,
        initialFlashcards[0].copyWith(id: 'f4'),
        initialFlashcards[1].copyWith(id: 'f5'),
      ];

      final List<Flashcard> duplicates = utils.lookForDuplicates(
        editedFlashcards,
      );

      expect(duplicates, [
        initialFlashcards[0],
        initialFlashcards[0].copyWith(id: 'f4'),
        initialFlashcards[1],
        initialFlashcards[1].copyWith(id: 'f5'),
      ]);
    });

    test('there is no duplicates', () {
      final List<Flashcard> duplicates = utils.lookForDuplicates(
        initialFlashcards,
      );

      expect(duplicates, []);
    });
  });
}
