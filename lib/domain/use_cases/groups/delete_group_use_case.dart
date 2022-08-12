import '../../../interfaces/groups_interface.dart';

class DeleteGroupUseCase {
  late final GroupsInterface _groupsInterface;

  DeleteGroupUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({required String groupId}) async {
    await _groupsInterface.deleteGroup(groupId);
  }
}
