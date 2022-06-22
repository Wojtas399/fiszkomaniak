import 'package:fiszkomaniak/components/group_item/group_item.dart';
import 'package:fiszkomaniak/features/course_groups_preview/bloc/course_groups_preview_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late CourseGroupsPreviewState state;

  setUp(() {
    state = CourseGroupsPreviewState();
  });

  test(
    'initial state',
    () {
      expect(state.courseName, '');
      expect(state.searchValue, '');
    },
  );

  test(
    'copy with course name',
    () {
      const String expectedCourseName = 'course name';

      final state2 = state.copyWith(courseName: expectedCourseName);
      final state3 = state2.copyWith();

      expect(state2.courseName, expectedCourseName);
      expect(state3.courseName, expectedCourseName);
    },
  );

  test(
    'copy with search value',
    () {
      const String expectedSearchValue = 'search value';

      final state2 = state.copyWith(searchValue: expectedSearchValue);
      final state3 = state2.copyWith();

      expect(state2.searchValue, expectedSearchValue);
      expect(state3.searchValue, expectedSearchValue);
    },
  );

  test(
    'copy with groups from course',
    () {
      final List<GroupItemParams> expectedGroupsItemsParams = [
        createGroupItemParams(name: 'group 1'),
        createGroupItemParams(name: 'group 2'),
      ];

      final state2 =
          state.copyWith(groupsFromCourse: expectedGroupsItemsParams);
      final state3 = state2.copyWith();

      expect(state2.groupsItemsParams, expectedGroupsItemsParams);
      expect(state3.groupsItemsParams, expectedGroupsItemsParams);
    },
  );

  group(
    'group items params',
    () {
      final List<GroupItemParams> groupsItemsParams = [
        createGroupItemParams(name: 'group 1'),
        createGroupItemParams(name: 'group name 2'),
        createGroupItemParams(name: 'group name 3'),
      ];

      test(
        'should return all groups from course if search value is empty string',
        () {
          const String searchValue = '';

          state = state.copyWith(
            groupsFromCourse: groupsItemsParams,
            searchValue: searchValue,
          );

          expect(state.groupsItemsParams, groupsItemsParams);
        },
      );

      test(
        'should return groups which match to the search value',
        () {
          const String searchValue = 'name';

          state = state.copyWith(
            groupsFromCourse: groupsItemsParams,
            searchValue: searchValue,
          );

          expect(
            state.groupsItemsParams,
            [groupsItemsParams[1], groupsItemsParams[2]],
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
      final List<GroupItemParams> groupsItemsParams = [
        createGroupItemParams(name: 'group 1'),
      ];

      state = state.copyWith(groupsFromCourse: groupsItemsParams);

      expect(state.areGroupsInCourse, true);
    },
  );
}
