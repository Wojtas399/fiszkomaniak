import '../../../interfaces/groups_interface.dart';
import '../../../domain/entities/group.dart';

class GetGroupsByCourseIdUseCase {
  late final GroupsInterface _groupsInterface;

  GetGroupsByCourseIdUseCase({required GroupsInterface groupsInterface}) {
    _groupsInterface = groupsInterface;
  }

  Stream<List<Group>> execute({required String courseId}) {
    return _groupsInterface.getGroupsByCourseId(courseId: courseId);
  }
}
