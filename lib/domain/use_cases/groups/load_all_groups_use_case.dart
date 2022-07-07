import 'package:fiszkomaniak/interfaces/groups_interface.dart';

class LoadAllGroupsUseCase {
  late final GroupsInterface _groupsInterface;

  LoadAllGroupsUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Future<void> execute() async {
    await _groupsInterface.loadAllGroups();
  }
}
