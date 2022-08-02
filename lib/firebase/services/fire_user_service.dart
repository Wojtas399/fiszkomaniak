import '../models/fire_doc_model.dart';
import '../models/user_db_model.dart';
import '../fire_instances.dart';
import '../fire_references.dart';
import '../fire_user.dart';

class FireUserService {
  String? getLoggedUserEmail() {
    return FireUser.loggedUserEmail ?? '';
  }

  Future<FireDoc<UserDbModel>?> loadLoggedUserData() async {
    final doc = await FireReferences.loggedUserRefWithConverter.get();
    final data = doc.data();
    if (data != null) {
      return FireDoc(id: doc.id, doc: data);
    }
    return null;
  }

  Future<void> addUserData(String userId, String username) async {
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
    final achievements = await FireReferences.achievementsRef.get();
    final sessions = await FireReferences.sessionsRef.get();
    for (final course in courses.docs) {
      batch.delete(course.reference);
    }
    for (final group in groups.docs) {
      batch.delete(group.reference);
    }
    for (final achievement in achievements.docs) {
      batch.delete(achievement.reference);
    }
    for (final session in sessions.docs) {
      batch.delete(session.reference);
    }
    batch.delete(FireReferences.appearanceSettingsRef);
    batch.delete(FireReferences.notificationsSettingsRef);
    batch.delete(FireReferences.loggedUserRef);
    await batch.commit();
  }
}
