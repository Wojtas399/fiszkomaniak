import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/delete_group_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = DeleteGroupUseCase(groupsInterface: groupsInterface);

  test(
    'should call method from groups interface responsible for deleting group',
    () async {
      when(
        () => groupsInterface.deleteGroup('g1'),
      ).thenAnswer((_) async => '');

      await useCase.execute(groupId: 'g1');

      verify(
        () => groupsInterface.deleteGroup('g1'),
      ).called(1);
    },
  );
}
