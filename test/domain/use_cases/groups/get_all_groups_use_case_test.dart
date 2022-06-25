import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_all_groups_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = GetAllGroupsUseCase(groupsInterface: groupsInterface);

  test(
    'should return all groups stream from groups interface',
    () async {
      final List<Group> groups = [
        createGroup(id: 'g1'),
        createGroup(id: 'g2'),
        createGroup(id: 'g3'),
      ];
      when(
        () => groupsInterface.allGroups$,
      ).thenAnswer((_) => Stream.value(groups));

      final Stream<List<Group>> allGroups$ = useCase.execute();

      expect(await allGroups$.first, groups);
    },
  );
}
