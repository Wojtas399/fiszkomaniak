import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';
import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';

class FireUserService {
  Future<DocumentSnapshot<UserDbModel>> loadLoggedUserData() async {
    return await FireReferences.loggedUserRefWithConverter.get();
  }

  Future<void> addUser(String userId, String username) async {
    try {
      await FireReferences.usersRef
          .doc(userId)
          .set(UserDbModel(username: username));
    } catch (error) {
      rethrow;
    }
  }

  Future<void> saveNewUsername(String newUsername) async {
    try {
      await FireReferences.loggedUserRef.update(
        UserDbModel(username: newUsername).toJson(),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> removeLoggedUserData() async {
    final batch = FireInstances.firestore.batch();
    final courses = await FireReferences.coursesRef.get();
    final groups = await FireReferences.groupsRef.get();
    for (final course in courses.docs) {
      batch.delete(course.reference);
    }
    for (final group in groups.docs) {
      batch.delete(group.reference);
    }
    batch.delete(FireReferences.appearanceSettingsRef);
    batch.delete(FireReferences.notificationsSettingsRef);
    batch.delete(FireReferences.loggedUserRef);
    await batch.commit();
  }
}
