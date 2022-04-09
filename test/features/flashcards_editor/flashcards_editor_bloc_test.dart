import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_bloc.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_event.dart';
import 'package:fiszkomaniak/features/flashcards_editor/bloc/flashcards_editor_state.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsBloc extends Mock implements GroupsBloc {}

void main() {
  final GroupsBloc groupsBloc = MockGroupsBloc();
  late FlashcardsEditorBloc bloc;

  setUp(() {
    bloc = FlashcardsEditorBloc(groupsBloc: groupsBloc);
  });

  tearDown(() {
    reset(groupsBloc);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => groupsBloc.state).thenReturn(
        GroupsState(allGroups: [
          createGroup(id: 'g1', name: 'group 1'),
          createGroup(id: 'g2', name: 'group 2'),
        ]),
      );
    },
    act: (_) => bloc.add(FlashcardsEditorEventInitialize(groupId: 'g1')),
    expect: () => [
      const FlashcardsEditorState(
        groupId: 'g1',
        groupName: 'group 1',
      ),
    ],
  );
}
