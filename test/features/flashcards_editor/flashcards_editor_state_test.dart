import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsEditorState state;
  final List<FlashcardsEditorItemParams> flashcards = [
    createFlashcardsEditorItemParams(
      index: 0,
      isNew: true,
      doc: createFlashcard(question: 'question', answer: 'answer'),
    ),
    createFlashcardsEditorItemParams(
      index: 1,
      isNew: false,
      doc: createFlashcard(id: 'f1'),
    ),
    createFlashcardsEditorItemParams(
      index: 2,
      isNew: true,
      doc: createFlashcard(),
    ),
  ];

  setUp(() {
    state = const FlashcardsEditorState();
  });

  test('initial state', () {
    expect(state.group, null);
    expect(state.flashcards, const []);
  });

  test('copy with group', () {
    final Group group = createGroup(id: 'g1');
    final FlashcardsEditorState state2 = state.copyWith(group: group);
    final FlashcardsEditorState state3 = state2.copyWith();

    expect(state2.group, group);
    expect(state3.group, group);
  });

  test('copy with flashcards', () {
    final FlashcardsEditorState state2 = state.copyWith(flashcards: flashcards);
    final FlashcardsEditorState state3 = state2.copyWith();

    expect(state2.flashcards, flashcards);
    expect(state3.flashcards, flashcards);
  });

  test('new flashcards', () {
    final FlashcardsEditorState updatedState = state.copyWith(
      flashcards: flashcards,
    );

    expect(updatedState.newFlashcards, [flashcards[0]]);
  });
}
