import 'package:fiszkomaniak/domain/use_cases/groups/update_group_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = UpdateGroupUseCase(groupsInterface: groupsInterface);

  test(
    'should call method from groups interface responsible for updating group',
    () async {
      when(
        () => groupsInterface.updateGroup(
          groupId: 'g1',
          name: 'new name',
          nameForAnswers: 'name for answers',
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        groupId: 'g1',
        name: 'new name',
        nameForAnswers: 'name for answers',
      );

      verify(
        () => groupsInterface.updateGroup(
          groupId: 'g1',
          name: 'new name',
          nameForAnswers: 'name for answers',
        ),
      ).called(1);
    },
  );
}
