import '../../../interfaces/groups_interface.dart';

class AddGroupUseCase {
  late final GroupsInterface _groupsInterface;

  AddGroupUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({
    required String name,
    required String courseId,
    required String nameForQuestions,
    required String nameForAnswers,
  }) async {
    await _groupsInterface.addNewGroup(
      name: name,
      courseId: courseId,
      nameForQuestions: nameForQuestions,
      nameForAnswers: nameForAnswers,
    );
  }
}
