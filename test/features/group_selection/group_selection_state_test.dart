import 'package:fiszkomaniak/features/group_selection/bloc/group_selection_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late GroupSelectionState state;
  final List<Course> courses = [
    createCourse(id: 'c1'),
    createCourse(id: 'c2'),
    createCourse(id: 'c3'),
  ];
  final List<Group> groups = [
    createGroup(
      id: 'g1',
      nameForQuestions: 'questions',
      nameForAnswers: 'answers',
    ),
    createGroup(id: 'g2'),
    createGroup(id: 'g3'),
    createGroup(id: 'g4'),
  ];

  setUp(() {
    state = GroupSelectionState();
  });

  test('initial state', () {
    expect(
      state,
      GroupSelectionState(
        allCourses: const [],
        groupsFromCourse: const [],
        selectedCourse: null,
        selectedGroup: null,
      ),
    );
    expect(state.coursesToSelect, {});
    expect(state.groupsFromCourseToSelect, {});
    expect(state.nameForQuestions, null);
    expect(state.nameForAnswers, null);
    expect(state.isButtonDisabled, true);
  });

  test('copy with all courses', () {
    final Map<String, String> coursesAsMap = {
      for (final course in courses) course.id: course.name,
    };
    final GroupSelectionState state2 = state.copyWith(allCourses: courses);
    final GroupSelectionState state3 = state2.copyWith();

    expect(state2.coursesToSelect, coursesAsMap);
    expect(state3.coursesToSelect, coursesAsMap);
  });

  test('copy with groups from course', () {
    final Map<String, String> groupsAsMap = {
      for (final group in groups) group.id: group.name,
    };
    final GroupSelectionState state2 = state.copyWith(groupsFromCourse: groups);
    final GroupSelectionState state3 = state2.copyWith();

    expect(state2.groupsFromCourseToSelect, groupsAsMap);
    expect(state3.groupsFromCourseToSelect, groupsAsMap);
  });

  test('copy with selected course', () {
    final GroupSelectionState state2 = state.copyWith(
      selectedCourse: courses[0],
    );
    final GroupSelectionState state3 = state2.copyWith();

    expect(state2.selectedCourse, courses[0]);
    expect(state3.selectedCourse, courses[0]);
  });

  test('copy with selected group', () {
    final GroupSelectionState state2 = state.copyWith(selectedGroup: groups[0]);
    final GroupSelectionState state3 = state2.copyWith();

    expect(state2.selectedGroup, groups[0]);
    expect(state3.selectedGroup, null);
  });

  test('name for questions, group selected', () {
    final GroupSelectionState updatedState = state.copyWith(
      selectedGroup: groups[0],
    );

    expect(updatedState.nameForQuestions, groups[0].nameForQuestions);
  });

  test('name for answers, group selected', () {
    final GroupSelectionState updatedState = state.copyWith(
      selectedGroup: groups[0],
    );

    expect(updatedState.nameForAnswers, groups[0].nameForAnswers);
  });

  test('is button disabled, course or group not selected', () {
    final GroupSelectionState updatedState = state.copyWith(
      selectedGroup: groups[0],
    );

    expect(updatedState.isButtonDisabled, true);
  });

  test('is button disabled, course and group selected', () {
    final GroupSelectionState updatedState = state.copyWith(
      selectedCourse: courses[0],
      selectedGroup: groups[0],
    );

    expect(updatedState.isButtonDisabled, false);
  });
}
