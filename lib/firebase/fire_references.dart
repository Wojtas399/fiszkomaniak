import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'fire_instances.dart';
import 'models/appearance_settings_db_model.dart';
import 'models/course_db_model.dart';
import 'models/flashcard_db_model.dart';
import 'models/group_db_model.dart';
import 'models/notifications_settings_db_model.dart';
import 'models/session_db_model.dart';
import 'models/user_db_model.dart';

class FireReferences {
  static DocumentReference get _loggedUserRef => FireUser.loggedUserRef;

  static CollectionReference get _settingsRef =>
      _loggedUserRef.collection('Settings');

  static CollectionReference get usersRef =>
      FireInstances.firestore.collection('Users').withConverter<UserDBModel>(
            fromFirestore: (snapshot, _) => UserDBModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (user, _) => user.toJson(),
          );

  static DocumentReference<AppearanceSettingsDbModel>
      get appearanceSettingsRef => _settingsRef
          .doc('Appearance')
          .withConverter<AppearanceSettingsDbModel>(
            fromFirestore: (snapshot, _) => AppearanceSettingsDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (settings, _) => settings.toJson(),
          );

  static DocumentReference<NotificationsSettingsDbModel>
      get notificationsSettingsRef => _settingsRef
          .doc('Notifications')
          .withConverter<NotificationsSettingsDbModel>(
            fromFirestore: (snapshot, _) =>
                NotificationsSettingsDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (settings, _) => settings.toJson(),
          );

  static CollectionReference<CourseDbModel> get coursesRef =>
      _loggedUserRef.collection('Courses').withConverter<CourseDbModel>(
            fromFirestore: (snapshot, _) => CourseDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (data, _) => data.toJson(),
          );

  static CollectionReference<GroupDbModel> get groupsReference =>
      _loggedUserRef.collection('Groups').withConverter<GroupDbModel>(
            fromFirestore: (snapshot, _) => GroupDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (data, _) => data.toJson(),
          );

  static CollectionReference<FlashcardDbModel> get flashcardsRef =>
      _loggedUserRef.collection('Flashcards').withConverter<FlashcardDbModel>(
            fromFirestore: (snapshot, _) => FlashcardDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (data, _) => data.toJson(),
          );

  static CollectionReference<SessionDbModel> get sessionsRef =>
      _loggedUserRef.collection('Sessions').withConverter<SessionDbModel>(
            fromFirestore: (snapshot, _) => SessionDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (data, _) => data.toJson(),
          );
}
