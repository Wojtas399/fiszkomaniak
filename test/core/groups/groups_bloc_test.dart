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
  late GroupsBloc bloc;
  final List<ChangedDocument<Group>> snapshots = [
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createGroup(id: 'g1'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createGroup(id: 'g2'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.added,
      doc: createGroup(id: 'g3', name: 'group3'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.updated,
      doc: createGroup(id: 'g3', name: 'group 3'),
    ),
    ChangedDocument(
      changeType: DbDocChangeType.removed,
      doc: createGroup(id: 'g3'),
    )
  ];

  setUp(() {
    bloc = GroupsBloc(groupsInterface: groupsInterface);
  });

  tearDown(() {
    reset(groupsInterface);
  });

  blocTest(
    'initialize',
    build: () => bloc,
    setUp: () {
      when(() => groupsInterface.getGroupsSnapshots())
          .thenAnswer((_) => Stream.value(snapshots));
    },
    act: (_) => bloc.add(GroupsEventInitialize()),
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
    build: () => bloc,
    act: (_) => bloc.add(GroupsEventGroupAdded(group: snapshots[0].doc)),
    expect: () => [
      GroupsState(
        allGroups: [snapshots[0].doc],
        status: GroupsStatusLoaded(),
      ),
    ],
  );

  blocTest(
    'group updated',
    build: () => bloc,
    act: (_) {
      bloc.add(GroupsEventGroupAdded(group: snapshots[2].doc));
      bloc.add(GroupsEventGroupUpdated(group: snapshots[3].doc));
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
    build: () => bloc,
    act: (_) {
      bloc.add(GroupsEventGroupAdded(group: snapshots[1].doc));
      bloc.add(GroupsEventGroupRemoved(groupId: 'g2'));
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
    build: () => bloc,
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
    act: (_) => bloc.add(
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
    build: () => bloc,
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
    act: (_) => bloc.add(
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
    'update group, success',
    build: () => bloc,
    setUp: () {
      when(
        () => groupsInterface.updateGroup(
          groupId: 'g1',
          name: 'name',
          courseId: 'c1',
        ),
      ).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(GroupsEventUpdateGroup(
      groupId: 'g1',
      name: 'name',
      courseId: 'c1',
    )),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: GroupsStatusGroupUpdated()),
    ],
    verify: (_) {
      verify(
        () => groupsInterface.updateGroup(
          groupId: 'g1',
          name: 'name',
          courseId: 'c1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'update group, failure',
    build: () => bloc,
    setUp: () {
      when(
        () => groupsInterface.updateGroup(
          groupId: 'g1',
          name: 'name',
          courseId: 'c1',
        ),
      ).thenThrow('Error...');
    },
    act: (_) => bloc.add(GroupsEventUpdateGroup(
      groupId: 'g1',
      name: 'name',
      courseId: 'c1',
    )),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: const GroupsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(
        () => groupsInterface.updateGroup(
          groupId: 'g1',
          name: 'name',
          courseId: 'c1',
        ),
      ).called(1);
    },
  );

  blocTest(
    'remove group, success',
    build: () => bloc,
    setUp: () {
      when(() => groupsInterface.removeGroup('g1')).thenAnswer((_) async => '');
    },
    act: (_) => bloc.add(GroupsEventRemoveGroup(groupId: 'g1')),
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
    build: () => bloc,
    setUp: () {
      when(() => groupsInterface.removeGroup('g1')).thenThrow('Error...');
    },
    act: (_) => bloc.add(GroupsEventRemoveGroup(groupId: 'g1')),
    expect: () => [
      GroupsState(status: GroupsStatusLoading()),
      GroupsState(status: const GroupsStatusError(message: 'Error...')),
    ],
    verify: (_) {
      verify(() => groupsInterface.removeGroup('g1')).called(1);
    },
  );
}
