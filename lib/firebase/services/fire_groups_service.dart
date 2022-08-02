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

  Future<FireDocument<GroupDbModel>?> addNewGroup(
    GroupDbModel groupData,
  ) async {
    final docRef = await FireReferences.groupsRefWithConverter.add(groupData);
    final doc = await docRef.get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<FireDocument<GroupDbModel>?> updateGroup({
    required String groupId,
    String? name,
    String? courseId,
    String? nameForQuestions,
    String? nameForAnswers,
  }) async {
    final docRef = FireReferences.groupsRefWithConverter.doc(groupId);
    await docRef.update(
      GroupDbModel(
        name: name,
        courseId: courseId,
        nameForQuestions: nameForQuestions,
        nameForAnswers: nameForAnswers,
      ).toJson(),
    );
    final doc = await docRef.get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<String> removeGroup(String groupId) async {
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
    return groupId;
  }

  Future<bool> isGroupNameInCourseAlreadyTaken({
    required String groupName,
    required String courseId,
  }) async {
    final query = await FireReferences.groupsRefWithConverter
        .where('courseId', isEqualTo: courseId)
        .where('name', isEqualTo: groupName)
        .get();
    return query.docs.isNotEmpty;
  }

  FireDocument<GroupDbModel>? _convertDocumentSnapshotToFireDocument(
    DocumentSnapshot<GroupDbModel> doc,
  ) {
    return FireUtils.convertDocumentSnapshotToFireDocument<GroupDbModel>(doc);
  }
}
