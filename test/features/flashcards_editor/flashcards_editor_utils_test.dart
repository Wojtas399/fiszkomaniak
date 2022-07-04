import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsEditorUtils utils;

  setUp(() => utils = FlashcardsEditorUtils());

  test(
    'create initial editor flashcards, should create editor flashcards and add one empty flashcard',
    () {
      final List<Flashcard> flashcards = [
        createFlashcard(
          index: 0,
          question: 'question0',
          answer: 'answer0',
          status: FlashcardStatus.notRemembered,
        ),
        createFlashcard(
          index: 1,
          question: 'question1',
          answer: 'answer1',
          status: FlashcardStatus.remembered,
        ),
      ];
      final List<EditorFlashcard> expectedEditorFlashcards = [
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'question0',
          answer: 'answer0',
          flashcardStatus: FlashcardStatus.notRemembered,
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
          question: 'question1',
          answer: 'answer1',
          flashcardStatus: FlashcardStatus.remembered,
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard2',
          question: '',
          answer: '',
          flashcardStatus: FlashcardStatus.notRemembered,
          completionStatus: EditorFlashcardCompletionStatus.unknown,
        )
      ];

      final result = utils.createInitialEditorFlashcards(flashcards);

      expect(result, expectedEditorFlashcards);
    },
  );

  test(
    'remove empty editor flashcards apart from last and edited one',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(key: 'f0', question: 'q0', answer: 'a0'),
        createEditorFlashcard(key: 'f1', question: '', answer: ''),
        createEditorFlashcard(key: 'f2', question: 'q2', answer: ''),
        createEditorFlashcard(key: 'f3', question: '', answer: ''),
        createEditorFlashcard(key: 'f4', question: '', answer: 'a4'),
        createEditorFlashcard(key: 'f5', question: '', answer: ''),
      ];
      final List<EditorFlashcard> expectedEditorFlashcards = [
        editorFlashcards[0],
        editorFlashcards[1],
        editorFlashcards[2],
        editorFlashcards[4],
        editorFlashcards[5],
      ];

      final result = utils.removeEmptyEditorFlashcardsApartFromLastAndEditedOne(
        editorFlashcards,
        1,
      );

      expect(result, expectedEditorFlashcards);
    },
  );

  test(
    'add new editor flashcard, should add new empty editor flashcard and return updated list',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'question0',
          answer: 'answer0',
          flashcardStatus: FlashcardStatus.notRemembered,
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
          question: 'question1',
          answer: 'answer1',
          flashcardStatus: FlashcardStatus.remembered,
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
      ];
      final List<EditorFlashcard> expectedEditorFlashcards = [
        ...editorFlashcards,
        createEditorFlashcard(
          key: 'flashcard2',
          question: '',
          answer: '',
          flashcardStatus: FlashcardStatus.notRemembered,
          completionStatus: EditorFlashcardCompletionStatus.unknown,
        ),
      ];

      final result = utils.addNewEditorFlashcard(editorFlashcards, 2);

      expect(result, expectedEditorFlashcards);
    },
  );

  test(
    'update completion status in editor flashcards marked as incomplete',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'question0',
          answer: 'answer0',
          completionStatus: EditorFlashcardCompletionStatus.incomplete,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
          question: 'answer1',
          answer: 'answer1',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard2',
          question: 'question2',
          answer: 'answer2',
          completionStatus: EditorFlashcardCompletionStatus.unknown,
        ),
        createEditorFlashcard(
          key: 'flashcard3',
          question: '',
          answer: 'answer3',
          completionStatus: EditorFlashcardCompletionStatus.incomplete,
        ),
      ];
      final List<EditorFlashcard> expectedEditorFlashcards = [
        editorFlashcards[0].copyWith(
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        editorFlashcards[1],
        editorFlashcards[2],
        editorFlashcards[3],
      ];

      final result =
          utils.updateCompletionStatusInEditorFlashcardsMarkedAsIncomplete(
        editorFlashcards,
      );

      expect(result, expectedEditorFlashcards);
    },
  );

  test(
    'convert editor flashcards to flashcards, should convert list of editor flashcard model to list of flashcard model',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'question0',
          answer: 'answer0',
          flashcardStatus: FlashcardStatus.remembered,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
          question: 'question1',
          answer: 'answer1',
          flashcardStatus: FlashcardStatus.notRemembered,
        ),
      ];
      final List<Flashcard> expectedFlashcards = [
        createFlashcard(
          index: 0,
          question: 'question0',
          answer: 'answer0',
          status: FlashcardStatus.remembered,
        ),
        createFlashcard(
          index: 1,
          question: 'question1',
          answer: 'answer1',
          status: FlashcardStatus.notRemembered,
        ),
      ];

      final result = utils.convertEditorFlashcardsToFlashcards(
        editorFlashcards,
      );

      expect(result, expectedFlashcards);
    },
  );

  test(
    'update editor flashcards completion statuses, should update completion statuses in flashcards depends on question and answer status',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(
          key: 'flashcard0',
          question: 'question0',
          answer: 'answer0',
          completionStatus: EditorFlashcardCompletionStatus.unknown,
        ),
        createEditorFlashcard(
          key: 'flashcard1',
          question: '',
          answer: 'answer1',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard2',
          question: 'question2',
          answer: '',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        createEditorFlashcard(
          key: 'flashcard3',
          question: 'question3',
          answer: 'answer3',
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
      ];
      final List<EditorFlashcard> expectedEditorFlashcards = [
        editorFlashcards[0].copyWith(
          completionStatus: EditorFlashcardCompletionStatus.complete,
        ),
        editorFlashcards[1].copyWith(
          completionStatus: EditorFlashcardCompletionStatus.incomplete,
        ),
        editorFlashcards[2].copyWith(
          completionStatus: EditorFlashcardCompletionStatus.incomplete,
        ),
        editorFlashcards[3],
      ];

      final result = utils.updateEditorFlashcardsCompletionStatuses(
        editorFlashcards,
      );

      expect(result, expectedEditorFlashcards);
    },
  );

  group(
    'are editor flashcards same as group flashcards',
    () {
      final List<Flashcard> groupFlashcards = [
        createFlashcard(
          index: 0,
          question: 'question0',
          answer: 'answer0',
          status: FlashcardStatus.remembered,
        ),
        createFlashcard(
          index: 1,
          question: 'question1',
          answer: 'answer1',
          status: FlashcardStatus.notRemembered,
        ),
      ];

      test(
        'should return true if they are the same',
        () {
          final List<EditorFlashcard> editorFlashcards = [
            createEditorFlashcard(
              key: 'flashcard0',
              question: 'question0',
              answer: 'answer0',
              flashcardStatus: FlashcardStatus.remembered,
            ),
            createEditorFlashcard(
              key: 'flashcard1',
              question: 'question1',
              answer: 'answer1',
              flashcardStatus: FlashcardStatus.notRemembered,
            ),
          ];

          final result = utils.areEditorFlashcardsSameAsGroupFlashcards(
            groupFlashcards,
            editorFlashcards,
          );

          expect(result, true);
        },
      );

      test(
        'should return false if they are not the same',
        () {
          final List<EditorFlashcard> editorFlashcards = [
            createEditorFlashcard(
              key: 'flashcard0',
              question: 'question0',
              answer: 'answer0',
              flashcardStatus: FlashcardStatus.remembered,
            ),
            createEditorFlashcard(
              key: 'flashcard1',
              question: 'question',
              answer: 'answer',
              flashcardStatus: FlashcardStatus.notRemembered,
            ),
          ];

          final result = utils.areEditorFlashcardsSameAsGroupFlashcards(
            groupFlashcards,
            editorFlashcards,
          );

          expect(result, false);
        },
      );
    },
  );

  test(
    'are there incomplete editor flashcards, should return true if there is at least one incomplete editor flashcard',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(key: 'f0', question: '', answer: 'a0'),
        createEditorFlashcard(key: 'f1', question: 'q1', answer: 'a1'),
      ];

      final result = utils.areThereIncompleteEditorFlashcards(editorFlashcards);

      expect(result, true);
    },
  );

  test(
    'are there incomplete editor flashcards, should return false if there is no any incomplete editor flashcard',
    () {
      final List<EditorFlashcard> editorFlashcards = [
        createEditorFlashcard(key: 'f0', question: 'q0', answer: 'a0'),
        createEditorFlashcard(key: 'f1', question: 'q1', answer: 'a1'),
      ];

      final result = utils.areThereIncompleteEditorFlashcards(editorFlashcards);

      expect(result, false);
    },
  );
}
