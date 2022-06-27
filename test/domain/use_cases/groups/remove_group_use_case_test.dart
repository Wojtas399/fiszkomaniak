import 'package:fiszkomaniak/domain/use_cases/groups/remove_group_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = RemoveGroupUseCase(groupsInterface: groupsInterface);

  test(
    'should call method from groups interface responsible for removing group',
    () async {
      when(() => groupsInterface.removeGroup('g1')).thenAnswer((_) async => '');

      await useCase.execute(groupId: 'g1');

      verify(() => groupsInterface.removeGroup('g1')).called(1);
    },
  );
}
