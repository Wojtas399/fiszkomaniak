import 'package:fiszkomaniak/domain/use_cases/groups/check_group_name_usage_in_course_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = CheckGroupNameUsageInCourseUseCase(
    groupsInterface: groupsInterface,
  );

  test(
    'should return result of method from groups interface responsible for checking if group name in specific course is already taken',
    () async {
      when(
        () => groupsInterface.isGroupNameInCourseAlreadyTaken(
          groupName: 'groupName',
          courseId: 'c1',
        ),
      ).thenAnswer((_) async => true);

      await useCase.execute(groupName: 'groupName', courseId: 'c1');

      verify(
        () => groupsInterface.isGroupNameInCourseAlreadyTaken(
          groupName: 'groupName',
          courseId: 'c1',
        ),
      ).called(1);
    },
  );
}
