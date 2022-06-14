import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_sessions_service.dart';
import '../fire_instances.dart';

class FireGroupsService {
  static Future<QuerySnapshot<GroupDbModel>> getGroupsFromCourse(
    String courseId,
  ) async {
    return await FireReferences.groupsRefWithConverter
        .where('courseId', isEqualTo: courseId)
        .get();
  }

  Stream<QuerySnapshot<GroupDbModel>> getGroupsSnapshots() {
    return FireReferences.groupsRefWithConverter.snapshots();
  }

  Future<List<DocumentSnapshot<GroupDbModel>>> getAllGroups() async {
    final docs = await FireReferences.groupsRefWithConverter.get();
    return docs.docChanges.map((docChange) => docChange.doc).toList();
  }

  Future<DocumentSnapshot<GroupDbModel>> loadGroup({
    required String groupId,
  }) async {
    return await FireReferences.groupsRefWithConverter.doc(groupId).get();
  }

  Future<void> addNewGroup(GroupDbModel groupData) async {
    try {
      await FireReferences.groupsRefWithConverter.add(groupData);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestions,
    String? nameForAnswers,
  }) async {
    try {
      await FireReferences.groupsRefWithConverter.doc(groupId).update(
            GroupDbModel(
              name: name,
              courseId: courseId,
              nameForQuestions: nameForQuestions,
              nameForAnswers: nameForAnswers,
            ).toJson(),
          );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeGroup(String groupId) async {
    try {
      final batch = FireInstances.firestore.batch();
      final group =
          await FireReferences.groupsRefWithConverter.doc(groupId).get();
      final sessionsFromGroups =
          await FireSessionsService.getSessionsByGroupsIds([groupId]);
      for (final session in sessionsFromGroups.docs) {
        batch.delete(session.reference);
      }
      batch.delete(group.reference);
      await batch.commit();
    } catch (error) {
      rethrow;
    }
  }
}
