import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = GetGroupUseCase(groupsInterface: groupsInterface);

  test(
    'should return stream with appropriate group',
    () async {
      final Group expectedGroup = createGroup(id: 'g1', name: 'group 1');
      when(
        () => groupsInterface.getGroupById(groupId: 'g1'),
      ).thenAnswer((_) => Stream.value(expectedGroup));

      final Stream<Group> group$ = useCase.execute(groupId: 'g1');

      expect(await group$.first, expectedGroup);
    },
  );
}
