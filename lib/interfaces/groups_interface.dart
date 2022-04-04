import 'package:fiszkomaniak/models/group_model.dart';
import '../models/changed_document.dart';

abstract class GroupsInterface {
  Stream<List<ChangedDocument<Group>>> getGroupsSnapshots();

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

  Future<void> removeGroupsFromCourse(String courseId);
}
