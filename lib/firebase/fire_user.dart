import 'package:fiszkomaniak/firebase/fire_instances.dart';

class FireUser {
  static String get noLoggedUserMessage => 'There is no logged user...';

  static String? getLoggedUserId() {
    return FireInstances.auth.currentUser?.uid;
  }
}
