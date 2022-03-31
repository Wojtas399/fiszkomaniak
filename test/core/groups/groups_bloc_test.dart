import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_event.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/groups/groups_status.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/models/changed_document.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final GroupsInterface groupsInterface = MockGroupsInterface();
  late GroupsBloc groupsBloc;
  final List<ChangedDocument<Group>> snapshots = [
    const ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: Group(
        id: 'g1',
        name: 'group 1',
        courseId: 'c1',
        nameForQuestions: 'nameQ1',
        nameForAnswers: 'nameA1',
      ),
    ),
    const ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: Group(
        id: 'g2',
        name: 'group 2',
        courseId: 'c2',
        nameForQuestions: 'nameQ2',
        nameForAnswers: 'nameA2',
      ),
    ),
    const ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: Group(
        id: 'g3',
        name: 'group 3',
        courseId: 'c2',
        nameForQuestions: 'nameQ3',
        nameForAnswers: 'nameA3',
      ),
    ),
    const ChangedDocument(
      changeType: DbDocChangeType.updated,
      doc: Group(
        id: 'g3',
        name: 'group name 3',
        courseId: 'c2',
        nameForQuestions: 'nameQ3',
        nameForAnswers: 'nameA3',
      ),
    ),
    const ChangedDocument(
      changeType: DbDocChangeType.removed,
      doc: Group(
        id: 'g3',
        name: 'group name 3',
        courseId: 'c2',
        nameForQuestions: 'nameQ3',
        nameForAnswers: 'nameA3',
      ),
    )
  ];

  setUp(() {
    groupsBloc = GroupsBloc(groupsInterface: groupsInterface);
  });

  tearDown(() {
    reset(groupsInterface);
  });

  blocTest(
    'initialize',
    build: () => groupsBloc,
    setUp: () {
      when(() => groupsInterface.getGroupsSnapshots())
          .thenAnswer((_) => Stream.value(snapshots));
    },
    act: (_) => groupsBloc.add(GroupsEventInitialize()),
    expect: () => [
      GroupsState(
        allGroups: [snapshots[0].doc],
        status: GroupsStatusLoaded(),
      ),
      GroupsState(
        allGroups: [snapshots[0].doc, snapshots[1].doc],
        status: GroupsStatusLoaded(),
      ),
      GroupsState(
        allGroups: [
          snapshots[0].doc,
          snapshots[1].doc,
          snapshots[2].doc,
        ],
        status: GroupsStatusLoaded(),
      ),
      GroupsState(
        allGroups: [
          snapshots[0].doc,
          snapshots[1].doc,
          snapshots[3].doc,
        ],
        status: GroupsStatusLoaded(),
      ),
      GroupsState(
        allGroups: [
          snapshots[0].doc,
          snapshots[1].doc,
        ],
        status: GroupsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'group added',
    build: () => groupsBloc,
    act: (_) => groupsBloc.add(GroupsEventGroupAdded(group: snapshots[0].doc)),
    expect: () => [
      GroupsState(
        allGroups: [snapshots[0].doc],
        status: GroupsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'group updated',
    build: () => groupsBloc,
    act: (_) {
      groupsBloc.add(GroupsEventGroupAdded(group: snapshots[2].doc));
      groupsBloc.add(GroupsEventGroupUpdated(group: snapshots[3].doc));
    },
    expect: () => [
      GroupsState(
        allGroups: [snapshots[2].doc],
        status: GroupsStatusLoaded(),
      ),
      GroupsState(
        allGroups: [snapshots[3].doc],
        status: GroupsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'group removed',
    build: () => groupsBloc,
    act: (_) {
      groupsBloc.add(GroupsEventGroupAdded(group: snapshots[1].doc));
      groupsBloc.add(GroupsEventGroupRemoved(groupId: 'g2'));
    },
    expect: () => [
      GroupsState(
        allGroups: [snapshots[1].doc],
        status: GroupsStatusLoaded(),
      ),
      GroupsState(
        allGroups: const [],
        status: GroupsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'add group, success',
    build: () => groupsBloc,
    setUp: () {
      when(
        () => groupsInterface.addNewGroup(
          name: 'name',
          courseId: 'courseId',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => groupsBloc.add(
      GroupsEventAddGroup(
        name: 'name',
        courseId: 'courseId',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      ),
    ),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: GroupsStatusGroupAdded()),
    ],
    verify: (_) {
      verify(
        () => groupsInterface.addNewGroup(
          name: 'name',
          courseId: 'courseId',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      );
    },
  );

  blocTest(
    'add group, failure',
    build: () => groupsBloc,
    setUp: () {
      when(
        () => groupsInterface.addNewGroup(
          name: 'name',
          courseId: 'courseId',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ).thenThrow('Error...');
    },
    act: (_) => groupsBloc.add(
      GroupsEventAddGroup(
        name: 'name',
        courseId: 'courseId',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      ),
    ),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: const GroupsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => groupsInterface.addNewGroup(
          name: 'name',
          courseId: 'courseId',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      );
    },
  );

  blocTest(
    'remove group, success',
    build: () => groupsBloc,
    setUp: () {
      when(() => groupsInterface.removeGroup('g1')).thenAnswer((_) async => '');
    },
    act: (_) => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: GroupsStatusGroupRemoved()),
    ],
    verify: (_) {
      verify(() => groupsInterface.removeGroup('g1')).called(1);
    },
  );

  blocTest(
    'remove group, failure',
    build: () => groupsBloc,
    setUp: () {
      when(() => groupsInterface.removeGroup('g1')).thenThrow('Error...');
    },
    act: (_) => groupsBloc.add(GroupsEventRemoveGroup(groupId: 'g1')),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: const GroupsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => groupsInterface.removeGroup('g1')).called(1);
    },
  );
}
