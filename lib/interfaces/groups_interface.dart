import 'package:fiszkomaniak/domain/entities/group.dart';

abstract class GroupsInterface {
  Stream<List<Group>> get allGroups$;

  Future<void> loadAllGroups();

  Future<void> addNewGroup({
    required String name,
    required String courseId,
    required String nameForQuestions,
    required String nameForAnswers,
  });

  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestion,
    String? nameForAnswers,
  });

  Future<void> removeGroup(String groupId);

  Stream<Group> getGroupById({required String groupId});

  Stream<List<Group>> getGroupsByCourseId({required String courseId});
}
