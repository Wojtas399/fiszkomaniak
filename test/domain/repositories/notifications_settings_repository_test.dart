import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:fiszkomaniak/domain/repositories/notifications_settings_repository.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_notifications_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireNotificationsSettingsService extends Mock
    implements FireNotificationsSettingsService {}

void main() {
  final fireNotificationsSettingsService =
      MockFireNotificationsSettingsService();
  late NotificationsSettingsRepository repository;

  setUp(
    () => repository = NotificationsSettingsRepository(
      fireNotificationsSettingsService: fireNotificationsSettingsService,
    ),
  );

  tearDown(() {
    reset(fireNotificationsSettingsService);
  });

  test(
    'set default settings, should call method responsible for setting default notifications settings',
    () async {
      when(
        () => fireNotificationsSettingsService.setDefaultSettings(),
      ).thenAnswer((_) async => '');

      await repository.setDefaultSettings();

      verify(
        () => fireNotificationsSettingsService.setDefaultSettings(),
      ).called(1);
    },
  );

  test(
    'load settings, should load notifications settings and add them to stream',
    () async {
      final dbNotificationsSettings = NotificationsSettingsDbModel(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: false,
        areLossOfDaysNotificationsOn: false,
      );
      const notificationsSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: false,
      );
      when(
        () => fireNotificationsSettingsService.loadSettings(),
      ).thenAnswer((_) async => dbNotificationsSettings);

      await repository.loadSettings();

      expect(
        await repository.notificationsSettings$.first,
        notificationsSettings,
      );
    },
  );

  test(
    'load settings, should throw error if one of parameters does not have value',
    () async {
      final dbNotificationsSettings = NotificationsSettingsDbModel(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: null,
        areAchievementsNotificationsOn: false,
        areLossOfDaysNotificationsOn: false,
      );
      when(
        () => fireNotificationsSettingsService.loadSettings(),
      ).thenAnswer((_) async => dbNotificationsSettings);

      try {
        await repository.loadSettings();
      } catch (error) {
        expect(error, 'Cannot load one of the notifications settings params');
      }
    },
  );

  test(
    'update settings, should update stream firstly and then should call method responsible for updating notifications settings',
    () async {
      const updatedNotificationsSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: false,
      );
      when(
        () => fireNotificationsSettingsService.updateSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysNotificationsOn: false,
        ),
      ).thenAnswer((_) async => '');

      await repository.updateSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: false,
      );

      expect(
        await repository.notificationsSettings$.first,
        updatedNotificationsSettings,
      );
      verify(
        () => fireNotificationsSettingsService.updateSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysNotificationsOn: false,
        ),
      ).called(1);
    },
  );

  test(
    'update settings, should set previous stream value if method responsible for updating notifications settings will throw error',
    () async {
      const initialNotificationsSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: true,
      );
      when(
        () => fireNotificationsSettingsService.updateSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysNotificationsOn: false,
        ),
      ).thenThrow('Error...');

      await repository.updateSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: false,
      );

      expect(
        await repository.notificationsSettings$.first,
        initialNotificationsSettings,
      );
      verify(
        () => fireNotificationsSettingsService.updateSettings(
          areSessionsPlannedNotificationsOn: true,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysNotificationsOn: false,
        ),
      ).called(1);
    },
  );
}
