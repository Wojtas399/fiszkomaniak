import 'package:fiszkomaniak/firebase/fire_instances.dart';
import 'package:fiszkomaniak/firebase/models/user_db_model.dart';

class FireUserService {
  final _usersRef =
      FireInstances.firestore.collection('Users').withConverter<UserDBModel>(
            fromFirestore: (snapshot, _) => UserDBModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (user, _) => user.toJson(),
          );

  Future<void> addUser(String userId, String username) async {
    try {
      await _usersRef
          .doc(userId)
          .set(UserDBModel(username: username, avatarPath: ''));
    } catch (error) {
      rethrow;
    }
  }
}
