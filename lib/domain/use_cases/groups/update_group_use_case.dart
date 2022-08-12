import '../../../interfaces/groups_interface.dart';

class UpdateGroupUseCase {
  late final GroupsInterface _groupsInterface;

  UpdateGroupUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestions,
    String? nameForAnswers,
  }) async {
    await _groupsInterface.updateGroup(
      groupId: groupId,
      name: name,
      courseId: courseId,
      nameForQuestion: nameForQuestions,
      nameForAnswers: nameForAnswers,
    );
  }
}
