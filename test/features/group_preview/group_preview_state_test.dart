import 'package:fiszkomaniak/features/group_preview/bloc/group_preview_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupPreviewState state;

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
    final Group group = createGroup(id: 'g1');

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

  test('copy with amount of all flashcards', () {
    const int amount = 5;

    final GroupPreviewState state2 = state.copyWith(
      amountOfAllFlashcards: amount,
    );
    final GroupPreviewState state3 = state2.copyWith();

    expect(state2.amountOfAllFlashcards, amount);
    expect(state3.amountOfAllFlashcards, amount);
  });

  test('copy with amount of remembered flashcards', () {
    const int amount = 2;

    final GroupPreviewState state2 = state.copyWith(
      amountOfRememberedFlashcards: amount,
    );
    final GroupPreviewState state3 = state2.copyWith();

    expect(state2.amountOfRememberedFlashcards, amount);
    expect(state3.amountOfRememberedFlashcards, amount);
  });
}
