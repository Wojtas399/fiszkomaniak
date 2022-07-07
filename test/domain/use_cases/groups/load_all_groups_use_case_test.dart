import 'package:fiszkomaniak/domain/use_cases/groups/load_all_groups_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = LoadAllGroupsUseCase(groupsInterface: groupsInterface);

  test(
    'should call method responsible for loading all groups',
    () async {
      when(() => groupsInterface.loadAllGroups()).thenAnswer((_) async => '');

      await useCase.execute();

      verify(() => groupsInterface.loadAllGroups()).called(1);
    },
  );
}
