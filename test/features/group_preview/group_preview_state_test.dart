import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupPreviewState state;
  final Group group = createGroup(id: 'g1', flashcards: [
    createFlashcard(index: 0, status: FlashcardStatus.remembered),
    createFlashcard(index: 1, status: FlashcardStatus.remembered),
    createFlashcard(index: 2, status: FlashcardStatus.notRemembered),
  ]);

  setUp(() {
    state = const GroupPreviewState();
  });

  test('initial state', () {
    expect(state.group, null);
    expect(state.courseName, '');
    expect(state.amountOfAllFlashcards, 0);
    expect(state.amountOfRememberedFlashcards, 0);
  });

  test('copy with group', () {
    final GroupPreviewState state2 = state.copyWith(group: group);
    final GroupPreviewState state3 = state2.copyWith();

    expect(state2.group, group);
    expect(state3.group, group);
  });

  test('copy with course name', () {
    const String courseName = 'course name';

    final GroupPreviewState state2 = state.copyWith(courseName: courseName);
    final GroupPreviewState state3 = state2.copyWith();

    expect(state2.courseName, courseName);
    expect(state3.courseName, courseName);
  });

  test('amount of all flashcards', () {
    final GroupPreviewState updatedState = state.copyWith(group: group);

    expect(updatedState.amountOfAllFlashcards, 3);
  });

  test('amount of remembered flashcards', () {
    final GroupPreviewState updatedState = state.copyWith(group: group);

    expect(updatedState.amountOfRememberedFlashcards, 2);
  });
}
