import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

void main() {
  late FlashcardsEditorState state;

  setUp(
    () => state = const FlashcardsEditorState(
      status: BlocStatusComplete(),
      group: null,
      editorFlashcards: [],
      keyCounter: 0,
    ),
  );

  test(
    'is editor flashcard marked as incomplete, should return true if editor flashcard is marked as incomplete',
    () {
      final EditorFlashcard editorFlashcard = createEditorFlashcard(
        key: 'flashcard0',
        completionStatus: EditorFlashcardCompletionStatus.incomplete,
      );

      final result = state.isEditorFlashcardMarkedAsIncomplete(editorFlashcard);

      expect(result, true);
    },
  );

  test(
    'is editor flashcard marked as incomplete, should return false if editor flashcard is not marked as incomplete',
    () {
      final EditorFlashcard editorFlashcard = createEditorFlashcard(
        key: 'flashcard0',
        completionStatus: EditorFlashcardCompletionStatus.unknown,
      );

      final result = state.isEditorFlashcardMarkedAsIncomplete(editorFlashcard);

      expect(result, false);
    },
  );

  test(
    'copy with status',
    () {
      const BlocStatus expectedBlocStatus = BlocStatusLoading();

      state = state.copyWith(status: expectedBlocStatus);
      final state2 = state.copyWith();

      expect(state.status, expectedBlocStatus);
      expect(state2.status, const BlocStatusInProgress());
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

      state = state.copyWith(group: expectedGroup);
      final state2 = state.copyWith();

      expect(state.group, expectedGroup);
      expect(state2.group, expectedGroup);
    },
  );

  test(
    'copy with editor flashcards',
    () {
      final List<EditorFlashcard> expectedEditorFlashcards = [
        createEditorFlashcard(key: 'f1', question: 'q1', answer: 'a1'),
        createEditorFlashcard(key: 'f2', question: 'q2', answer: 'a2'),
      ];

      state = state.copyWith(editorFlashcards: expectedEditorFlashcards);
      final state2 = state.copyWith();

      expect(state.editorFlashcards, expectedEditorFlashcards);
      expect(state2.editorFlashcards, expectedEditorFlashcards);
    },
  );

  test(
    'copy with key counter',
    () {
      const int expectedKeyCounter = 2;

      state = state.copyWith(keyCounter: expectedKeyCounter);
      final state2 = state.copyWith();

      expect(state.keyCounter, expectedKeyCounter);
      expect(state2.keyCounter, expectedKeyCounter);
    },
  );

  test(
    'copy with info',
    () {
      const FlashcardsEditorInfo expectedInfo =
          FlashcardsEditorInfo.editedFlashcardsHaveBeenSaved;

      state = state.copyWithInfo(expectedInfo);

      expect(
        state.status,
        const BlocStatusComplete<FlashcardsEditorInfo>(
          info: expectedInfo,
        ),
      );
    },
  );

  test(
    'copy with error',
    () {
      const FlashcardsEditorError expectedError =
          FlashcardsEditorError.incompleteFlashcardsExist;

      state = state.copyWithError(expectedError);

      expect(
        state.status,
        const BlocStatusError<FlashcardsEditorError>(
          error: expectedError,
        ),
      );
    },
  );
}
