import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'fire_instances.dart';
import 'models/achievement_db_model.dart';
import 'models/appearance_settings_db_model.dart';
import 'models/course_db_model.dart';
import 'models/group_db_model.dart';
import 'models/notifications_settings_db_model.dart';
import 'models/session_db_model.dart';
import 'models/user_db_model.dart';

class FireReferences {
  static DocumentReference get loggedUserRef =>
      FireInstances.firestore.collection('Users').doc(FireUser.loggedUserId);

  static CollectionReference get settingsRef =>
      loggedUserRef.collection('Settings');

  static DocumentReference get appearanceSettingsRef =>
      settingsRef.doc('Appearance');

  static DocumentReference get notificationsSettingsRef =>
      settingsRef.doc('Notifications');

  static CollectionReference get coursesRef =>
      loggedUserRef.collection('Courses');

  static CollectionReference get groupsRef =>
      loggedUserRef.collection('Groups');

  static CollectionReference get sessionsRef =>
      loggedUserRef.collection('Sessions');

  static CollectionReference get achievementsRef =>
      loggedUserRef.collection('Achievements');

  static Reference get avatarRef => FireInstances.storage.ref(
        'Avatars/${FireUser.loggedUserId}.jpg',
      );

  static DocumentReference<UserDbModel> get loggedUserRefWithConverter =>
      loggedUserRef.withConverter<UserDbModel>(
        fromFirestore: (snapshot, _) => UserDbModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (settings, _) => settings.toJson(),
      );

  static CollectionReference get usersRef =>
      FireInstances.firestore.collection('Users').withConverter<UserDbModel>(
            fromFirestore: (snapshot, _) => UserDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (user, _) => user.toJson(),
          );

  static DocumentReference<AppearanceSettingsDbModel>
      get appearanceSettingsRefWithConverter =>
          appearanceSettingsRef.withConverter<AppearanceSettingsDbModel>(
            fromFirestore: (snapshot, _) => AppearanceSettingsDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (settings, _) => settings.toJson(),
          );

  static DocumentReference<NotificationsSettingsDbModel>
      get notificationsSettingsRefWithConverter =>
          notificationsSettingsRef.withConverter<NotificationsSettingsDbModel>(
            fromFirestore: (snapshot, _) =>
                NotificationsSettingsDbModel.fromJson(
              snapshot.data()!,
            ),
            toFirestore: (settings, _) => settings.toJson(),
          );

  static CollectionReference<CourseDbModel> get coursesRefWithConverter =>
      coursesRef.withConverter<CourseDbModel>(
        fromFirestore: (snapshot, _) => CourseDbModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (data, _) => data.toJson(),
      );

  static CollectionReference<GroupDbModel> get groupsRefWithConverter =>
      groupsRef.withConverter<GroupDbModel>(
        fromFirestore: (snapshot, _) => GroupDbModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (data, _) => data.toJson(),
      );

  static CollectionReference<SessionDbModel> get sessionsRefWithConverter =>
      sessionsRef.withConverter<SessionDbModel>(
        fromFirestore: (snapshot, _) => SessionDbModel.fromJson(
          snapshot.data()!,
        ),
        toFirestore: (data, _) => data.toJson(),
      );

  static CollectionReference<AchievementDbModel>
      get achievementsRefWithConverter =>
          achievementsRef.withConverter<AchievementDbModel>(
            fromFirestore: (snapshot, _) =>
                AchievementDbModel.fromJson(snapshot.data()!),
            toFirestore: (data, _) => data.toJson(),
          );
}
