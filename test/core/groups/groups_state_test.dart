import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/groups/groups_status.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupsState groupsState;
  final allGroups = [
    const Group(
      id: 'g1',
      name: 'group 1',
      courseId: 'c1',
      nameForQuestions: 'nameQ1',
      nameForAnswers: 'nameA1',
    ),
    const Group(
      id: 'g2',
      name: 'group 2',
      courseId: 'c2',
      nameForQuestions: 'nameQ2',
      nameForAnswers: 'nameA2',
    ),
    const Group(
      id: 'g3',
      name: 'group 3',
      courseId: 'c2',
      nameForQuestions: 'nameQ3',
      nameForAnswers: 'nameA3',
    ),
  ];

  setUp(() {
    groupsState = GroupsState();
  });

  test('initial state', () {
    expect(groupsState.allGroups, []);
    expect(groupsState.status, const GroupsStatusInitial());
  });

  test('copy with all groups', () {
    GroupsState updatedState = groupsState.copyWith(allGroups: allGroups);

    expect(updatedState.allGroups, allGroups);
    expect(updatedState.status, GroupsStatusLoaded());
  });

  test('copy with status', () {
    GroupsState updatedState = groupsState.copyWith(
      status: GroupsStatusGroupRemoved(),
    );

    expect(updatedState.allGroups, []);
    expect(updatedState.status, GroupsStatusGroupRemoved());
  });

  test('get group by id, group exists', () {
    GroupsState updatedState = groupsState.copyWith(allGroups: allGroups);

    Group? group = updatedState.getGroupById('g2');

    expect(group, allGroups[1]);
  });

  test('get group by id, group does not exist', () {
    GroupsState updatedState = groupsState.copyWith(allGroups: allGroups);

    Group? group = updatedState.getGroupById('g4');

    expect(group, null);
  });

  test('get groups by courseId', () {
    GroupsState updatedState = groupsState.copyWith(allGroups: allGroups);

    List<Group> groupsFromCourse = updatedState.getGroupsByCourseId('c2');

    expect(groupsFromCourse, [allGroups[1], allGroups[2]]);
  });
}