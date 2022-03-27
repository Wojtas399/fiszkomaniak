import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'package:fiszkomaniak/firebase/models/group_db_model.dart';
import '../fire_instances.dart';

class FireGroupsService {
  Stream<QuerySnapshot<GroupDbModel>> getGroupsSnapshots() {
    final String? loggedUserId = FireUser.getLoggedUserId();
    if (loggedUserId != null) {
      return _getGroupsRef(loggedUserId).snapshots();
    } else {
      throw FireUser.noLoggedUserMessage;
    }
  }

  Future<void> addNewGroup(GroupDbModel groupData) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getGroupsRef(loggedUserId).add(groupData);
      } else {
        throw FireUser.noLoggedUserMessage;
      }
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
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getGroupsRef(loggedUserId).doc(groupId).update(
              GroupDbModel(
                name: name,
                courseId: courseId,
                nameForQuestions: nameForQuestions,
                nameForAnswers: nameForAnswers,
              ).toJson(),
            );
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeGroup(String groupId) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        await _getGroupsRef(loggedUserId).doc(groupId).delete();
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  CollectionReference<GroupDbModel> _getGroupsRef(
    String userId,
  ) {
    return FireInstances.firestore
        .collection('Users')
        .doc(userId)
        .collection('Groups')
        .withConverter<GroupDbModel>(
          fromFirestore: (snapshot, _) => GroupDbModel.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (data, _) => data.toJson(),
        );
  }
}
