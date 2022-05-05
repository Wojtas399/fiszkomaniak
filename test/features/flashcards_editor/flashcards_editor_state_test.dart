import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/flashcards_editor_mode.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsEditorState state;
  final List<EditorFlashcard> flashcards = [
    createEditorFlashcard(
      key: 'f1',
      doc: createFlashcard(index: 0, question: 'question', answer: 'answer'),
    ),
    createEditorFlashcard(
      key: 'f2',
      doc: createFlashcard(index: 1),
    ),
    createEditorFlashcard(
      key: 'f3',
      doc: createFlashcard(index: 2),
    ),
  ];

  setUp(() {
    state = const FlashcardsEditorState();
  });

  test('initial state', () {
    expect(state.mode, null);
    expect(state.group, null);
    expect(state.flashcards, const []);
    expect(state.keyCounter, 0);
  });

  test('copy with mode', () {
    const FlashcardsEditorMode mode = FlashcardsEditorAddMode(groupId: 'g1');

    final FlashcardsEditorState state2 = state.copyWith(mode: mode);
    final FlashcardsEditorState state3 = state2.copyWith();

    expect(state2.mode, mode);
    expect(state3.mode, mode);
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

  test('copy with key counter', () {
    final FlashcardsEditorState state2 = state.copyWith(keyCounter: 2);
    final FlashcardsEditorState state3 = state2.copyWith();

    expect(state2.keyCounter, 2);
    expect(state3.keyCounter, 2);
  });

  test('get flashcards without last one', () {
    final List<Flashcard> expectedFlashcards = flashcards
        .getRange(0, flashcards.length - 1)
        .map((flashcard) => flashcard.doc)
        .toList();

    state = state.copyWith(flashcards: flashcards);

    expect(state.flashcardsWithoutLastOne, expectedFlashcards);
  });

  test('are incorrect flashcards', () {
    final List<EditorFlashcard> editedFlashcards = [
      ...flashcards,
      createEditorFlashcard(isCorrect: false),
    ];

    state = state.copyWith(flashcards: editedFlashcards);

    expect(state.areIncorrectFlashcards, true);
  });
}
