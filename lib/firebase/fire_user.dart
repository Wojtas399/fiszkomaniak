import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_instances.dart';

class FireUser {
  static String get noLoggedUserMessage => 'There is no logged user...';

  static DocumentReference get loggedUserRef =>
      FireInstances.firestore.collection('Users').doc(getLoggedUserId());

  static String? getLoggedUserId() {
    return FireInstances.auth.currentUser?.uid;
  }
}
