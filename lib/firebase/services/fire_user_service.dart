import 'package:fiszkomaniak/firebase/fire_references.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';

class FireUserService {
  Future<void> addUser(String userId, String username) async {
    try {
      await FireReferences.usersRef
          .doc(userId)
          .set(UserDBModel(username: username, avatarPath: ''));
    } catch (error) {
      rethrow;
    }
  }
}
