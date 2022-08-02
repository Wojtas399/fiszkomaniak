import 'package:fiszkomaniak/domain/use_cases/groups/add_group_use_case.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGroupsInterface extends Mock implements GroupsInterface {}

void main() {
  final groupsInterface = MockGroupsInterface();
  final useCase = AddGroupUseCase(groupsInterface: groupsInterface);

  test(
    'should call method from groups interface responsible for adding new group',
    () async {
      when(
        () => groupsInterface.addNewGroup(
          name: 'name',
          courseId: 'courseId',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ).thenAnswer((_) async => '');

      await useCase.execute(
        name: 'name',
        courseId: 'courseId',
        nameForQuestions: 'nameForQuestions',
        nameForAnswers: 'nameForAnswers',
      );

      verify(
        () => groupsInterface.addNewGroup(
          name: 'name',
          courseId: 'courseId',
          nameForQuestions: 'nameForQuestions',
          nameForAnswers: 'nameForAnswers',
        ),
      ).called(1);
    },
  );
}
