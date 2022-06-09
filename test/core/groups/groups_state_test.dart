import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupsState state;
  final allGroups = [
    createGroup(
      id: 'g1',
      name: 'group 1',
      courseId: 'c1',
      nameForQuestions: 'nameQ1',
      nameForAnswers: 'nameA1',
      flashcards: [],
    ),
    createGroup(
      id: 'g2',
      name: 'group 2',
      courseId: 'c2',
      nameForQuestions: 'nameQ2',
      nameForAnswers: 'nameA2',
    ),
    createGroup(
      id: 'g3',
      name: 'group 3',
      courseId: 'c2',
      nameForQuestions: 'nameQ3',
      nameForAnswers: 'nameA3',
    ),
  ];

  setUp(() {
    state = GroupsState(allGroups: allGroups);
  });

  test('initial state', () {
    const GroupsState initialState = GroupsState();
    expect(initialState.initializationStatus, InitializationStatus.loading);
    expect(initialState.allGroups, []);
    expect(initialState.status, const GroupsStatusInitial());
  });

  test('copy with initialization status', () {
    const InitializationStatus status = InitializationStatus.ready;

    final GroupsState state2 = state.copyWith(initializationStatus: status);
    final GroupsState state3 = state2.copyWith();

    expect(state2.initializationStatus, status);
    expect(state3.initializationStatus, status);
  });

  test('copy with all groups', () {
    final GroupsState state2 = state.copyWith();

    expect(state.allGroups, allGroups);
    expect(state2.allGroups, allGroups);
  });

  test('copy with status', () {
    final GroupsState state2 = state.copyWith(
      status: GroupsStatusGroupRemoved(),
    );
    final GroupsState state3 = state2.copyWith();

    expect(state2.status, GroupsStatusGroupRemoved());
    expect(state3.status, GroupsStatusLoaded());
  });

  test('get group by id, group exists', () {
    Group? group = state.getGroupById('g2');

    expect(group, allGroups[1]);
  });

  test('get group by id, group does not exist', () {
    Group? group = state.getGroupById('g4');

    expect(group, null);
  });

  test('get groups by course id', () {
    List<Group> groupsFromCourse = state.getGroupsByCourseId('c2');

    expect(groupsFromCourse, [allGroups[1], allGroups[2]]);
  });

  test('get groups ids by course id', () {
    List<String> ids = state.getGroupsIdsByCourseId('c2');

    expect(ids, ['g2', 'g3']);
  });

  test('get group name by id, group exists', () {
    String? groupName = state.getGroupNameById('g1');

    expect(groupName, allGroups[0].name);
  });

  test('get group name by id, group does not exist', () {
    String? groupName = state.getGroupNameById('g4');

    expect(groupName, null);
  });

  test('is there group with the same name in the same course, true', () {
    final bool answer = state.isThereGroupWithTheSameNameInTheSameCourse(
      'group 1',
      'c1',
    );

    expect(answer, true);
  });

  test(
    'is there group with the same name in the same course, the same name and course id',
    () {
      final bool answer = state.isThereGroupWithTheSameNameInTheSameCourse(
        'group 1',
        'c1',
      );

      expect(answer, true);
    },
  );

  test(
    'is there group with the same name in the same course, different name',
    () {
      final bool answer = state.isThereGroupWithTheSameNameInTheSameCourse(
        'group1',
        'c1',
      );

      expect(answer, false);
    },
  );

  test(
    'is there group with the same name in the same course, different course id',
    () {
      final bool answer = state.isThereGroupWithTheSameNameInTheSameCourse(
        'group 1',
        'c2',
      );

      expect(answer, false);
    },
  );
}
