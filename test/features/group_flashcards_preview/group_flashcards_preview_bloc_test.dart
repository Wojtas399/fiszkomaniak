import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_event.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_state.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

class MockFlashcardsBloc extends Mock implements FlashcardsBloc {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  final FlashcardsBloc flashcardsBloc = MockFlashcardsBloc();
  late GroupFlashcardsPreviewBloc bloc;
  final GroupsState groupsState = GroupsState(
    allGroups: [
      createGroup(id: 'g1', name: 'group name 1'),
      createGroup(id: 'g2', name: 'group name 2'),
    ],
  );
  final FlashcardsState flashcardsState = FlashcardsState(
    allFlashcards: [
      createFlashcard(id: 'f1', groupId: 'g1'),
      createFlashcard(id: 'f2', groupId: 'g2'),
      createFlashcard(id: 'f3', groupId: 'g1'),
      createFlashcard(id: 'f4', groupId: 'g2'),
    ],
  );

  setUp(() {
    bloc = GroupFlashcardsPreviewBloc(
      groupsBloc: groupsBloc,
      flashcardsBloc: flashcardsBloc,
    );
  });

  tearDown(() {
    reset(groupsBloc);
    reset(flashcardsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => groupsBloc.state).thenReturn(groupsState);
      when(() => flashcardsBloc.state).thenReturn(flashcardsState);
    },
    act: (_) => bloc.add(GroupFlashcardsPreviewEventInitialize(groupId: 'g1')),
    expect: () => [
      GroupFlashcardsPreviewState(
        groupId: 'g1',
        groupName: 'group name 1',
        flashcardsFromGroup: [
          flashcardsState.allFlashcards[0],
          flashcardsState.allFlashcards[2],
        ],
      ),
    ],
  );

  blocTest(
    'search value changed',
    build: () => bloc,
    act: (_) => bloc.add(
      GroupFlashcardsPreviewEventSearchValueChanged(
        searchValue: 'search value',
      ),
    ),
    expect: () => [
      const GroupFlashcardsPreviewState(searchValue: 'search value'),
    ],
  );
}
