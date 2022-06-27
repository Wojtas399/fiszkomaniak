import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import '../../entities/group.dart';

class GetGroupUseCase {
  late final GroupsInterface _groupsInterface;

  GetGroupUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Stream<Group> execute({required String groupId}) {
    return _groupsInterface.getGroupById(groupId: groupId);
  }
}
