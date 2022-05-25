import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';

class FireSessionsService {
  static Future<QuerySnapshot<SessionDbModel>> getSessionsByGroupsIds(
    List<String> groupsIds,
  ) async {
    return await FireReferences.sessionsRefWithConverter
        .where('groupId', whereIn: groupsIds)
        .get();
  }

  Stream<QuerySnapshot<SessionDbModel>> getSessionsSnapshots() {
    return FireReferences.sessionsRefWithConverter.snapshots();
  }

  Future<String> addNewSession(SessionDbModel sessionData) async {
    final doc = await FireReferences.sessionsRefWithConverter.add(sessionData);
    return doc.id;
  }

  Future<void> updateSession(FireDoc<SessionDbModel> sessionData) async {
    await FireReferences.sessionsRefWithConverter.doc(sessionData.id).update(
          sessionData.doc.toJson(),
        );
  }

  Future<void> removeSession(String sessionId) async {
    try {
      await FireReferences.sessionsRefWithConverter.doc(sessionId).delete();
    } catch (error) {
      rethrow;
    }
  }
}
