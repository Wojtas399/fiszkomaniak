import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';

class FireUser {
  static String get noLoggedUserMessage => 'There is no logged user...';

  static User? get loggedUser => FireInstances.auth.currentUser;

  static String? get loggedUserId => loggedUser?.uid;

  static String? get loggedUserEmail => loggedUser?.email;
}
