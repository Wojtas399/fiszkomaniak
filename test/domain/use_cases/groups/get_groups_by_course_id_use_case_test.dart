import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_groups_by_course_id_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = GetGroupsByCourseIdUseCase(groupsInterface: groupsInterface);

  test(
    'should return stream which contains groups from course',
    () async {
      final List<Group> expectedGroups = [
        createGroup(id: 'g1'),
        createGroup(id: 'g2'),
      ];
      when(
        () => groupsInterface.getGroupsByCourseId(courseId: 'c1'),
      ).thenAnswer((_) => Stream.value(expectedGroups));

      final Stream<List<Group>> groupsFromCourse$ = useCase.execute(
        courseId: 'c1',
      );

      expect(await groupsFromCourse$.first, expectedGroups);
    },
  );
}
