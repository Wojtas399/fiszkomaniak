import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardPreviewState state;

  setUp(() {
    state = const FlashcardPreviewState();
  });

  test('initial state', () {
    expect(state.flashcard, null);
    expect(state.group, null);
    expect(state.courseName, '');
  });

  test('copy with flashcard', () {
    final Flashcard flashcard = createFlashcard(id: 'f1');

    final FlashcardPreviewState state2 = state.copyWith(flashcard: flashcard);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.flashcard, flashcard);
    expect(state3.flashcard, flashcard);
  });

  test('copy with group', () {
    final Group group = createGroup(id: 'g1');

    final FlashcardPreviewState state2 = state.copyWith(group: group);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.group, group);
    expect(state3.group, group);
  });

  test('copy with course name', () {
    const String courseName = 'course name';

    final FlashcardPreviewState state2 = state.copyWith(courseName: courseName);
    final FlashcardPreviewState state3 = state2.copyWith();

    expect(state2.courseName, courseName);
    expect(state3.courseName, courseName);
  });
}
