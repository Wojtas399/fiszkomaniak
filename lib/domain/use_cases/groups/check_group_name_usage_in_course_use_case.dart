import '../../../interfaces/groups_interface.dart';

class CheckGroupNameUsageInCourseUseCase {
  late final GroupsInterface _groupsInterface;

  CheckGroupNameUsageInCourseUseCase({
    required GroupsInterface groupsInterface,
  }) {
    _groupsInterface = groupsInterface;
  }

  Future<bool> execute({
    required String groupName,
    required String courseId,
  }) async {
    return await _groupsInterface.isGroupNameInCourseAlreadyTaken(
      groupName: groupName,
      courseId: courseId,
    );
  }
}
