import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';
import 'package:flutter_test/flutter_test.dart';

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

      final state2 = state.copyWith(status: expectedBlocStatus);
      final state3 = state2.copyWith();

      expect(state2.status, expectedBlocStatus);
      expect(
        state3.status,
        const BlocStatusComplete<FlashcardsEditorInfoType>(),
      );
    },
  );

  test(
    'copy with group',
    () {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');

      final state2 = state.copyWith(group: expectedGroup);
      final state3 = state2.copyWith();

      expect(state2.group, expectedGroup);
      expect(state3.group, expectedGroup);
    },
  );

  test(
    'copy with editor flashcards',
    () {
      final List<EditorFlashcard> expectedEditorFlashcards = [
        createEditorFlashcard(key: 'f1', question: 'q1', answer: 'a1'),
        createEditorFlashcard(key: 'f2', question: 'q2', answer: 'a2'),
      ];

      final state2 = state.copyWith(editorFlashcards: expectedEditorFlashcards);
      final state3 = state2.copyWith();

      expect(state2.editorFlashcards, expectedEditorFlashcards);
      expect(state3.editorFlashcards, expectedEditorFlashcards);
    },
  );

  test(
    'copy with key counter',
    () {
      const int expectedKeyCounter = 2;

      final state2 = state.copyWith(keyCounter: expectedKeyCounter);
      final state3 = state2.copyWith();

      expect(state2.keyCounter, expectedKeyCounter);
      expect(state3.keyCounter, expectedKeyCounter);
    },
  );
}
