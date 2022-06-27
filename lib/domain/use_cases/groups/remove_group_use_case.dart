import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class RemoveGroupUseCase {
  late final GroupsInterface _groupsInterface;

  RemoveGroupUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute({required String groupId}) async {
    await _groupsInterface.removeGroup(groupId);
  }
}
