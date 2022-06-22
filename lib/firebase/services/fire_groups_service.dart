import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/fire_utils.dart';
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

  Future<List<FireDocument<GroupDbModel>>> loadAllGroups() async {
    final docs = await FireReferences.groupsRefWithConverter.get();
    final groupsSnapshots =
        docs.docChanges.map((docChange) => docChange.doc).toList();
    return groupsSnapshots
        .map(_convertDocumentSnapshotToFireDocument)
        .whereType<FireDocument<GroupDbModel>>()
        .toList();
  }

  Future<FireDocument<GroupDbModel>?> loadGroupById({
    required String groupId,
  }) async {
    final doc = await FireReferences.groupsRefWithConverter.doc(groupId).get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<void> addNewGroup(GroupDbModel groupData) async {
    await FireReferences.groupsRefWithConverter.add(groupData);
  }

  Future<void> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestions,
    String? nameForAnswers,
  }) async {
    await FireReferences.groupsRefWithConverter.doc(groupId).update(
          GroupDbModel(
            name: name,
            courseId: courseId,
            nameForQuestions: nameForQuestions,
            nameForAnswers: nameForAnswers,
          ).toJson(),
        );
  }

  Future<void> removeGroup(String groupId) async {
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
  }

  FireDocument<GroupDbModel>? _convertDocumentSnapshotToFireDocument(
    DocumentSnapshot<GroupDbModel> doc,
  ) {
    return FireUtils.convertDocumentSnapshotToFireDocument<GroupDbModel>(doc);
  }
}
