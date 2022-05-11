import 'package:fiszkomaniak/firebase/fire_instances.dart';

class FireUser {
  static String get noLoggedUserMessage => 'There is no logged user...';

  static String? get loggedUserId => FireInstances.auth.currentUser?.uid;

  static String? get loggedUserEmail => FireInstances.auth.currentUser?.email;
}
