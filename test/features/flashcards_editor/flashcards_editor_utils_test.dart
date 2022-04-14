import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
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

  test('are flashcards completed correctly, true', () {
    final List<Flashcard> flashcards = [
      createFlashcard(id: 'f1', question: 'q1', answer: 'a1'),
      createFlashcard(id: 'f2', question: 'q2', answer: 'a2'),
      createFlashcard(id: 'f3', question: 'q3', answer: 'a3'),
    ];

    final bool answer = utils.areFlashcardsCompletedCorrectly(flashcards);

    expect(answer, true);
  });

  test(
    'are flashcards completed correctly, one flashcard has empty field',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(id: 'f1', question: 'q1', answer: 'a1'),
        createFlashcard(id: 'f2', question: '', answer: 'a2'),
        createFlashcard(id: 'f3', question: 'q3', answer: 'a3'),
      ];

      final bool answer = utils.areFlashcardsCompletedCorrectly(flashcards);

      expect(answer, false);
    },
  );

  test(
    'are flashcards completed correctly, some flashcards have empty fields',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(id: 'f1', question: 'q1', answer: ''),
        createFlashcard(id: 'f2', question: '', answer: 'a2'),
        createFlashcard(id: 'f3', question: 'q3', answer: 'a3'),
      ];

      final bool answer = utils.areFlashcardsCompletedCorrectly(flashcards);

      expect(answer, false);
    },
  );

  test(
    'group flashcards, new flashcard',
    () {
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
    },
  );

  test(
    'group flashcards, new empty flashcard',
    () {
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
    },
  );

  test(
    'group flashcards, edited flashcard',
    () {
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
    },
  );

  test(
    'group flashcards, edited flashcard, isEmpty',
    () {
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
    },
  );

  test(
    'group flashcards, removed flashcard',
    () {
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
    },
  );

  test("are flashcard's both fields completed, true", () {
    final bool answer = utils.areFlashcardBothFieldsCompleted(
      initialFlashcards[0],
    );

    expect(answer, true);
  });

  test("are flashcard's both fields completed, false", () {
    final Flashcard editedFlashcard = initialFlashcards[0].copyWith(answer: '');

    final bool answer = utils.areFlashcardBothFieldsCompleted(editedFlashcard);

    expect(answer, false);
  });
}
