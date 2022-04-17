import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_state.dart';
import 'package:fiszkomaniak/models/course_model.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CourseGroupsPreviewState state;

  setUp(() {
    state = const CourseGroupsPreviewState();
  });

  test('initial state', () {
    expect(state.course, null);
    expect(state.groupsFromCourse, []);
    expect(state.searchValue, '');
  });

  test('copy with course', () {
    final Course course = createCourse(id: 'c1');

    final CourseGroupsPreviewState state2 = state.copyWith(course: course);
    final CourseGroupsPreviewState state3 = state2.copyWith();

    expect(state2.course, course);
    expect(state3.course, course);
  });

  test('copy with groups from course', () {
    final List<Group> groups = [
      createGroup(id: 'g1'),
      createGroup(id: 'g2'),
      createGroup(id: 'g3'),
    ];

    final CourseGroupsPreviewState state2 = state.copyWith(
      groupsFromCourse: groups,
    );
    final CourseGroupsPreviewState state3 = state2.copyWith();

    expect(state2.groupsFromCourse, groups);
    expect(state3.groupsFromCourse, groups);
  });

  test('copy with search value', () {
    const String searchValue = 'search value';

    final CourseGroupsPreviewState state2 = state.copyWith(
      searchValue: searchValue,
    );
    final CourseGroupsPreviewState state3 = state2.copyWith();

    expect(state2.searchValue, searchValue);
    expect(state3.searchValue, searchValue);
  });

  test('matched groups', () {
    final List<Group> groups = [
      createGroup(id: 'g1', name: 'group 1'),
      createGroup(id: 'g2', name: 'sport'),
      createGroup(id: 'g3', name: 'games'),
    ];

    final CourseGroupsPreviewState updatedState = state.copyWith(
      groupsFromCourse: groups,
      searchValue: 'o',
    );

    expect(updatedState.matchingGroups, [groups[0], groups[1]]);
  });

  test('course name', () {
    final Course course = createCourse(id: 'c1', name: 'course 1 name');

    final CourseGroupsPreviewState updatedState =
        state.copyWith(course: course);

    expect(updatedState.courseName, course.name);
  });
}
