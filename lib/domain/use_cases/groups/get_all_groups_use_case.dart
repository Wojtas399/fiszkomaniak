import '../../../domain/entities/group.dart';
import '../../../interfaces/groups_interface.dart';

class GetAllGroupsUseCase {
  late final GroupsInterface _groupsInterface;

  GetAllGroupsUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Stream<List<Group>> execute() {
    return _groupsInterface.allGroups$;
  }
}
