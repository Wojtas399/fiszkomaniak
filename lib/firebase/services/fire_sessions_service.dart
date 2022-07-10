import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_document.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/fire_utils.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';

class FireSessionsService {
  static Future<QuerySnapshot<SessionDbModel>> getSessionsByGroupsIds(
    List<String> groupsIds,
  ) async {
    return await FireReferences.sessionsRefWithConverter
        .where('groupId', whereIn: groupsIds)
        .get();
  }

  Future<List<FireDocument<SessionDbModel>>> loadAllSessions() async {
    final docs = await FireReferences.sessionsRefWithConverter.get();
    final sessionsSnapshots =
        docs.docChanges.map((docChange) => docChange.doc).toList();
    return sessionsSnapshots
        .map(_convertDocumentSnapshotToFireDocument)
        .whereType<FireDocument<SessionDbModel>>()
        .toList();
  }

  Future<FireDocument<SessionDbModel>?> addNewSession({
    required String groupId,
    required String flashcardsType,
    required bool areQuestionsAndAnswersSwapped,
    required String date,
    required String time,
    required String? duration,
    required String? notificationTime,
  }) async {
    final docRef = await FireReferences.sessionsRefWithConverter.add(
      SessionDbModel(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        time: time,
        duration: duration,
        notificationTime: notificationTime,
      ),
    );
    final doc = await docRef.get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<FireDocument<SessionDbModel>?> updateSession({
    required String sessionId,
    String? groupId,
    String? flashcardsType,
    bool? areQuestionsAndAnswersSwapped,
    String? date,
    String? time,
    String? duration,
    String? notificationTime,
  }) async {
    final docRef = FireReferences.sessionsRefWithConverter.doc(sessionId);
    await docRef.update(
      SessionDbModel(
        groupId: groupId,
        flashcardsType: flashcardsType,
        areQuestionsAndAnswersSwapped: areQuestionsAndAnswersSwapped,
        date: date,
        time: time,
        duration: duration,
        notificationTime: notificationTime,
      ).toJson(),
    );
    final doc = await docRef.get();
    return _convertDocumentSnapshotToFireDocument(doc);
  }

  Future<void> removeSession(String sessionId) async {
    await FireReferences.sessionsRefWithConverter.doc(sessionId).delete();
  }

  FireDocument<SessionDbModel>? _convertDocumentSnapshotToFireDocument(
    DocumentSnapshot<SessionDbModel> doc,
  ) {
    return FireUtils.convertDocumentSnapshotToFireDocument<SessionDbModel>(doc);
  }
}
