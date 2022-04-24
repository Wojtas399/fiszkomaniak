import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/models/fire_doc_model.dart';
import 'package:fiszkomaniak/firebase/models/session_db_model.dart';
import '../fire_instances.dart';
import '../fire_user.dart';

class FireSessionsService {
  Stream<QuerySnapshot<SessionDbModel>> getSessionsSnapshots() {
    final String? loggedUserId = FireUser.getLoggedUserId();
    if (loggedUserId != null) {
      return _getSessionsRef(loggedUserId).snapshots();
    } else {
      throw FireUser.noLoggedUserMessage;
    }
  }

  Future<void> addNewSession(SessionDbModel sessionData) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getSessionsRef(loggedUserId).add(sessionData);
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateSession(FireDoc<SessionDbModel> sessionData) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getSessionsRef(loggedUserId).doc(sessionData.id).update(
              sessionData.doc.toJson(),
            );
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeSession(String sessionId) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getSessionsRef(loggedUserId).doc(sessionId).delete();
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeSessionsByGroupsIds(List<String> groupsIds) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        final batch = FireInstances.firestore.batch();
        final matchedDocuments = await _getSessionsRef(loggedUserId)
            .where('groupId', whereIn: groupsIds)
            .get();
        for (final document in matchedDocuments.docs) {
          batch.delete(document.reference);
        }
        await batch.commit();
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<SessionDbModel> _getSessionsRef(
    String userId,
  ) {
    return FireInstances.firestore
        .collection('Users')
        .doc(userId)
        .collection('Sessions')
        .withConverter<SessionDbModel>(
          fromFirestore: (snapshot, _) => SessionDbModel.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (data, _) => data.toJson(),
        );
  }
}
