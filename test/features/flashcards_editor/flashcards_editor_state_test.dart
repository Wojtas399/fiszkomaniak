import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FlashcardsEditorState state;

  setUp(() {
    state = const FlashcardsEditorState();
  });

  test('initial state', () {
    expect(state.groupId, '');
    expect(state.groupName, '');
  });

  test('copy with group id', () {
    final FlashcardsEditorState state2 = state.copyWith(groupId: 'g1');
    final FlashcardsEditorState state3 = state2.copyWith();

    expect(state2.groupId, 'g1');
    expect(state3.groupId, 'g1');
  });

  test('copy with group name', () {
    final FlashcardsEditorState state2 = state.copyWith(groupName: 'group 1');
    final FlashcardsEditorState state3 = state2.copyWith();

    expect(state2.groupName, 'group 1');
    expect(state3.groupName, 'group 1');
  });
}
