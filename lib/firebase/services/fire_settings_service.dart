import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiszkomaniak/firebase/fire_user.dart';
import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';
import '../fire_instances.dart';

class FireSettingsService {
  Future<void> setDefaultSettings() async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        _getAppearanceSettingsRef(loggedUserId).set(
          AppearanceSettingsDbModel(
            isDarkModeOn: false,
            isDarkModeCompatibilityWithSystemOn: false,
            isSessionTimerInvisibilityOn: false,
          ),
        );
        _getNotificationsSettingsRef(loggedUserId).set(
          NotificationsSettingsDbModel(
            areSessionsPlannedNotificationsOn: true,
            areSessionsDefaultNotificationsOn: true,
            areAchievementsNotificationsOn: true,
            areLossOfDaysNotificationsOn: true,
          ),
        );
      } else {
        throw 'There is no logged user.';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<AppearanceSettingsDbModel> loadAppearanceSettings() async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        final settings = await _getAppearanceSettingsRef(loggedUserId).get();
        final settingsData = settings.data();
        if (settingsData != null) {
          return settingsData;
        } else {
          throw 'Cannot find appearance settings for this user.';
        }
      } else {
        throw 'There is no logged user.';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<NotificationsSettingsDbModel> loadNotificationsSettings() async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        final settings = await _getNotificationsSettingsRef(loggedUserId).get();
        final settingsData = settings.data();
        if (settingsData != null) {
          return settingsData;
        } else {
          throw 'Cannot find notifications settings for this user.';
        }
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateAppearanceSettings({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        _getAppearanceSettingsRef(loggedUserId).update(
          AppearanceSettingsDbModel(
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
            isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
          ).toJson(),
        );
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> updateNotificationsSettings({
    bool? areSessionsPlannedNotificationsOn,
    bool? areSessionsDefaultNotificationsOn,
    bool? areAchievementsNotificationsOn,
    bool? areLossOfDaysNotificationsOn,
  }) async {
    try {
      final String? loggedUserId = FireUser.getLoggedUserId();
      if (loggedUserId != null) {
        _getNotificationsSettingsRef(loggedUserId).update(
          NotificationsSettingsDbModel(
            areSessionsPlannedNotificationsOn:
                areSessionsPlannedNotificationsOn,
            areSessionsDefaultNotificationsOn:
                areSessionsDefaultNotificationsOn,
            areAchievementsNotificationsOn: areAchievementsNotificationsOn,
            areLossOfDaysNotificationsOn: areLossOfDaysNotificationsOn,
          ).toJson(),
        );
      } else {
        throw FireUser.noLoggedUserMessage;
      }
    } catch (error) {
      rethrow;
    }
  }

  DocumentReference<AppearanceSettingsDbModel> _getAppearanceSettingsRef(
    String userId,
  ) {
    return FireInstances.firestore
        .collection('Users')
        .doc(userId)
        .collection('Settings')
        .doc('Appearance')
        .withConverter<AppearanceSettingsDbModel>(
          fromFirestore: (snapshot, _) => AppearanceSettingsDbModel.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (settings, _) => settings.toJson(),
        );
  }

  DocumentReference<NotificationsSettingsDbModel> _getNotificationsSettingsRef(
    String userId,
  ) {
    return FireInstances.firestore
        .collection('Users')
        .doc(userId)
        .collection('Settings')
        .doc('Notifications')
        .withConverter<NotificationsSettingsDbModel>(
          fromFirestore: (snapshot, _) => NotificationsSettingsDbModel.fromJson(
            snapshot.data()!,
          ),
          toFirestore: (settings, _) => settings.toJson(),
        );
  }
}
