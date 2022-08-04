import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/repositories/settings_repository.dart';
import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_appearance_settings_service.dart';
import 'package:fiszkomaniak/firebase/services/fire_notifications_settings_service.dart';

class MockFireAppearanceSettingsService extends Mock
    implements FireAppearanceSettingsService {}

class MockFireNotificationsSettingsService extends Mock
    implements FireNotificationsSettingsService {}

void main() {
  final fireAppearanceSettingsService = MockFireAppearanceSettingsService();
  final fireNotificationsSettingsService =
      MockFireNotificationsSettingsService();
  late SettingsRepository repository;
  final dbAppearanceSettings = AppearanceSettingsDbModel(
    isDarkModeOn: false,
    isDarkModeCompatibilityWithSystemOn: false,
    isSessionTimerInvisibilityOn: true,
  );
  final dbNotificationsSettings = NotificationsSettingsDbModel(
    areSessionsScheduledNotificationsOn: false,
    areSessionsDefaultNotificationsOn: false,
    areAchievementsNotificationsOn: true,
    areLossOfDaysNotificationsOn: true,
  );
  const initialAppearanceSettings = AppearanceSettings(
    isDarkModeOn: false,
    isDarkModeCompatibilityWithSystemOn: false,
    isSessionTimerInvisibilityOn: false,
  );
  const initialNotificationsSettings = NotificationsSettings(
    areSessionsScheduledNotificationsOn: true,
    areSessionsDefaultNotificationsOn: true,
    areAchievementsNotificationsOn: true,
    areLossOfDaysStreakNotificationsOn: true,
  );
  final appearanceSettings = initialAppearanceSettings.copyWith(
    isSessionTimerInvisibilityOn: true,
  );
  final notificationsSettings = initialNotificationsSettings.copyWith(
    areSessionsScheduledNotificationsOn: false,
    areSessionsDefaultNotificationsOn: false,
  );

  setUp(() {
    repository = SettingsRepository(
      fireAppearanceSettingsService: fireAppearanceSettingsService,
      fireNotificationsSettingsService: fireNotificationsSettingsService,
    );
    when(
      () => fireAppearanceSettingsService.loadSettings(),
    ).thenAnswer((_) async => dbAppearanceSettings);
    when(
      () => fireNotificationsSettingsService.loadSettings(),
    ).thenAnswer((_) async => dbNotificationsSettings);
  });

  tearDown(() {
    reset(fireAppearanceSettingsService);
    reset(fireNotificationsSettingsService);
  });

  test(
    'initial settings',
    () async {
      final Stream<Settings> settings$ = repository.settings$;
      expect(
        await settings$.first,
        const Settings(
          appearanceSettings: initialAppearanceSettings,
          notificationsSettings: initialNotificationsSettings,
        ),
      );
    },
  );

  test(
    'settings, should return stream which contains all settings',
    () async {
      await repository.loadSettings();

      final Stream<Settings> settings$ = repository.settings$;
      expect(
        await settings$.first,
        Settings(
          appearanceSettings: appearanceSettings,
          notificationsSettings: notificationsSettings,
        ),
      );
    },
  );

  test(
    'appearance settings, should return stream which contains appearance settings',
    () async {
      await repository.loadSettings();

      final Stream<AppearanceSettings> appearanceSettings$ =
          repository.appearanceSettings$;
      expect(
        await appearanceSettings$.first,
        appearanceSettings,
      );
    },
  );

  test(
    'notifications settings, should return stream which contains notifications settings',
    () async {
      await repository.loadSettings();

      final Stream<NotificationsSettings> notificationsSettings$ =
          repository.notificationsSettings$;
      expect(
        await notificationsSettings$.first,
        notificationsSettings,
      );
    },
  );

  test(
    'set default settings, should call methods responsible for setting default appearance and notifications settings',
    () async {
      when(
        () => fireAppearanceSettingsService.setDefaultSettings(),
      ).thenAnswer((_) async => '');
      when(
        () => fireNotificationsSettingsService.setDefaultSettings(),
      ).thenAnswer((_) async => '');

      await repository.setDefaultSettings();

      verify(
        () => fireAppearanceSettingsService.setDefaultSettings(),
      ).called(1);
      verify(
        () => fireNotificationsSettingsService.setDefaultSettings(),
      ).called(1);
    },
  );

  test(
    'load settings, should load settings from db and assign them to settings stream',
    () async {
      await repository.loadSettings();

      verify(
        () => fireAppearanceSettingsService.loadSettings(),
      ).called(1);
      verify(
        () => fireNotificationsSettingsService.loadSettings(),
      ).called(1);
      expect(
        await repository.settings$.first,
        Settings(
          appearanceSettings: appearanceSettings,
          notificationsSettings: notificationsSettings,
        ),
      );
    },
  );

  test(
    'update appearance settings, should update settings in stream and then should call method responsible for updating appearance settings',
    () async {
      when(
        () => fireAppearanceSettingsService.updateSettings(
          isDarkModeOn: true,
        ),
      ).thenAnswer((_) async => '');

      await repository.loadSettings();
      await repository.updateAppearanceSettings(isDarkModeOn: true);

      final Stream<AppearanceSettings> appearanceSettings$ =
          repository.appearanceSettings$;
      expect(
        await appearanceSettings$.first,
        appearanceSettings.copyWith(isDarkModeOn: true),
      );
      verify(
        () => fireAppearanceSettingsService.updateSettings(
          isDarkModeOn: true,
        ),
      ).called(1);
    },
  );

  test(
    'update appearance settings, should set previous settings in stream if method responsible for updating appearance settings throws error',
    () async {
      when(
        () => fireAppearanceSettingsService.updateSettings(
          isDarkModeOn: true,
        ),
      ).thenThrow('Error...');

      await repository.loadSettings();
      await repository.updateAppearanceSettings(isDarkModeOn: true);

      final Stream<AppearanceSettings> appearanceSettings$ =
          repository.appearanceSettings$;
      expect(
        await appearanceSettings$.first,
        appearanceSettings,
      );
      verify(
        () => fireAppearanceSettingsService.updateSettings(
          isDarkModeOn: true,
        ),
      ).called(1);
    },
  );

  test(
    'update notifications settings, should update settings in stream and then should call method responsible for updating notifications settings',
    () async {
      when(
        () => fireNotificationsSettingsService.updateSettings(
          areLossOfDaysNotificationsOn: false,
        ),
      ).thenAnswer((_) async => '');

      await repository.loadSettings();
      await repository.updateNotificationsSettings(
        areLossOfDaysStreakNotificationsOn: false,
      );

      final Stream<NotificationsSettings> notificationsSettings$ =
          repository.notificationsSettings$;
      expect(
        await notificationsSettings$.first,
        notificationsSettings.copyWith(
          areLossOfDaysStreakNotificationsOn: false,
        ),
      );
      verify(
        () => fireNotificationsSettingsService.updateSettings(
          areLossOfDaysNotificationsOn: false,
        ),
      ).called(1);
    },
  );

  test(
    'update notifications settings, should set previous settings in stream if method responsible for updating notifications settings throws error',
    () async {
      when(
        () => fireNotificationsSettingsService.updateSettings(
          areLossOfDaysNotificationsOn: false,
        ),
      ).thenThrow('Error...');

      await repository.loadSettings();
      await repository.updateNotificationsSettings(
        areLossOfDaysStreakNotificationsOn: false,
      );

      final Stream<NotificationsSettings> notificationsSettings$ =
          repository.notificationsSettings$;
      expect(
        await notificationsSettings$.first,
        notificationsSettings,
      );
      verify(
        () => fireNotificationsSettingsService.updateSettings(
          areLossOfDaysNotificationsOn: false,
        ),
      ).called(1);
    },
  );

  test(
    'reset, should set initial settings',
    () async {
      await repository.loadSettings();
      repository.reset();

      final Stream<Settings> settings$ = repository.settings$;
      expect(
        await settings$.first,
        const Settings(
          appearanceSettings: initialAppearanceSettings,
          notificationsSettings: initialNotificationsSettings,
        ),
      );
    },
  );
}
