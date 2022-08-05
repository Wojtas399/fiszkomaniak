import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';

void main() {
  late CourseGroupsPreviewState state;

  setUp(() {
    state = const CourseGroupsPreviewState(
      courseName: '',
      searchValue: '',
      groupsFromCourse: [],
    );
  });

  group(
    'group from course matching to search value',
    () {
      final List<Group> groups = [
        createGroup(name: 'group 1'),
        createGroup(name: 'group name 2'),
        createGroup(name: 'group name 3'),
      ];

      test(
        'should return all groups from course if search value is empty string',
        () {
          const String searchValue = '';

          state = state.copyWith(
            groupsFromCourse: groups,
            searchValue: searchValue,
          );

          expect(state.groupsFromCourseMatchingToSearchValue, groups);
        },
      );

      test(
        'should return groups which match to the search value',
        () {
          const String searchValue = 'name';

          state = state.copyWith(
            groupsFromCourse: groups,
            searchValue: searchValue,
          );

          expect(
            state.groupsFromCourseMatchingToSearchValue,
            [groups[1], groups[2]],
          );
        },
      );
    },
  );

  test(
    'are groups in course, should return false if there are no groups in course',
    () {
      expect(state.areGroupsInCourse, false);
    },
  );

  test(
    'are groups in course, should return true if there is at least one group in course',
    () {
      final List<Group> groups = [
        createGroup(name: 'group 1'),
      ];

      state = state.copyWith(groupsFromCourse: groups);

      expect(state.areGroupsInCourse, true);
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedCourseName = 'course name';

      state = state.copyWith(courseName: expectedCourseName);
      final state2 = state.copyWith();

      expect(state.courseName, expectedCourseName);
      expect(state2.courseName, expectedCourseName);
    },
  );

  test(
    'copy with search value',
    () {
      const String expectedSearchValue = 'search value';

      state = state.copyWith(searchValue: expectedSearchValue);
      final state2 = state.copyWith();

      expect(state.searchValue, expectedSearchValue);
      expect(state2.searchValue, expectedSearchValue);
    },
  );

  test(
    'copy with groups from course',
    () {
      final List<Group> expectedGroups = [
        createGroup(name: 'group 1'),
        createGroup(name: 'group 2'),
      ];

      state = state.copyWith(groupsFromCourse: expectedGroups);
      final state2 = state.copyWith();

      expect(state.groupsFromCourse, expectedGroups);
      expect(state2.groupsFromCourse, expectedGroups);
    },
  );
}
