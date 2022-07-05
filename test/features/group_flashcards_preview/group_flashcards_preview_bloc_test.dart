import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/flashcard.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/features/group_flashcards_preview/bloc/group_flashcards_preview_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

void main() {
  final getGroupUseCase = MockGetGroupUseCase();

  GroupFlashcardsPreviewBloc createBloc({
    String? groupId,
    String? groupName,
    List<Flashcard>? flashcards,
    String? searchValue,
  }) {
    return GroupFlashcardsPreviewBloc(
      getGroupUseCase: getGroupUseCase,
      groupId: groupId,
      groupName: groupName,
      flashcards: flashcards,
      searchValue: searchValue,
    );
  }

  GroupFlashcardsPreviewState createState({
    String groupId = '',
    String groupName = '',
    List<Flashcard> flashcardsFromGroup = const [],
    String searchValue = '',
  }) {
    return GroupFlashcardsPreviewState(
      groupId: groupId,
      groupName: groupName,
      flashcardsFromGroup: flashcardsFromGroup,
      searchValue: searchValue,
    );
  }

  group(
    'initialize',
    () {
      final Group group = createGroup(
        id: 'g1',
        name: 'group name',
        flashcards: [
          createFlashcard(index: 0, question: 'q0', answer: 'a0'),
          createFlashcard(index: 1, question: 'q1', answer: 'a1'),
        ],
      );

      blocTest(
        'should load group, update group id, name and flashcards in state and should set group listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(group));
        },
        act: (GroupFlashcardsPreviewBloc bloc) {
          bloc.add(GroupFlashcardsPreviewEventInitialize(groupId: 'g1'));
        },
        expect: () => [
          createState(
            groupId: group.id,
            groupName: group.name,
            flashcardsFromGroup: group.flashcards,
          ),
        ],
        verify: (_) {
          verify(() => getGroupUseCase.execute(groupId: 'g1')).called(2);
        },
      );
    },
  );

  blocTest(
    'search value changed, should update search value in state',
    build: () => createBloc(),
    act: (GroupFlashcardsPreviewBloc bloc) {
      bloc.add(
        GroupFlashcardsPreviewEventSearchValueChanged(
          searchValue: 'searchValue',
        ),
      );
    },
    expect: () => [
      createState(searchValue: 'searchValue'),
    ],
  );

  group(
    'group changed',
    () {
      final Group group = createGroup(
        id: 'g1',
        name: 'group name',
        flashcards: [
          createFlashcard(index: 0, question: 'q0', answer: 'a0'),
        ],
      );

      blocTest(
        'should update group id, name and flashcards in state',
        build: () => createBloc(),
        act: (GroupFlashcardsPreviewBloc bloc) {
          bloc.add(GroupFlashcardsPreviewEventGroupChanged(group: group));
        },
        expect: () => [
          createState(
            groupId: group.id,
            groupName: group.name,
            flashcardsFromGroup: group.flashcards,
          ),
        ],
      );
    },
  );
}
