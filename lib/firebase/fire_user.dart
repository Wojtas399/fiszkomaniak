import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';

class FireUser {
  static String get noLoggedUserMessage => 'There is no logged user...';

  static String? getLoggedUserId() {
    User? loggedUser = FireInstances.auth.currentUser;
    if (loggedUser != null) {
      return loggedUser.uid;
    }
    return null;
  }
}
