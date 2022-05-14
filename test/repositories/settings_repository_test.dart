import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/models/notifications_settings_db_model.dart';
import 'package:fiszkomaniak/repositories/settings_repository.dart';
import 'package:fiszkomaniak/firebase/services/fire_settings_service.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:fiszkomaniak/models/settings/notifications_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireSettingsService extends Mock implements FireSettingsService {}

void main() {
  final FireSettingsService fireSettingsService = MockFireSettingsService();
  late SettingsRepository fireSettingsRepository;

  setUp(() {
    fireSettingsRepository = SettingsRepository(
      fireSettingsService: fireSettingsService,
    );
  });

  tearDown(() {
    reset(fireSettingsService);
  });

  test('set default settings', () async {
    when(() => fireSettingsService.setDefaultSettings())
        .thenAnswer((_) async => '');

    await fireSettingsRepository.setDefaultUserSettings();

    verify(() => fireSettingsService.setDefaultSettings()).called(1);
  });

  test('load appearance settings, all params loaded', () async {
    when(() => fireSettingsService.loadAppearanceSettings()).thenAnswer(
      (_) async => AppearanceSettingsDbModel(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
    );

    AppearanceSettings settings =
        await fireSettingsRepository.loadAppearanceSettings();

    verify(() => fireSettingsService.loadAppearanceSettings()).called(1);
    expect(settings.isDarkModeOn, true);
    expect(settings.isDarkModeCompatibilityWithSystemOn, false);
    expect(settings.isSessionTimerInvisibilityOn, false);
  });

  test('load appearance settings, not all params loaded', () async {
    when(() => fireSettingsService.loadAppearanceSettings()).thenAnswer(
      (_) async => AppearanceSettingsDbModel(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
      ),
    );

    try {
      await fireSettingsRepository.loadAppearanceSettings();
    } catch (error) {
      verify(() => fireSettingsService.loadAppearanceSettings()).called(1);
      expect(error, 'Cannot load one of the appearance settings.');
    }
  });

  test('load notifications settings, all params loaded', () async {
    when(() => fireSettingsService.loadNotificationsSettings()).thenAnswer(
      (_) async => NotificationsSettingsDbModel(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: false,
        areLossOfDaysNotificationsOn: false,
      ),
    );

    NotificationsSettings settings =
        await fireSettingsRepository.loadNotificationsSettings();

    verify(() => fireSettingsService.loadNotificationsSettings()).called(1);
    expect(settings.areSessionsPlannedNotificationsOn, true);
    expect(settings.areSessionsDefaultNotificationsOn, true);
    expect(settings.areAchievementsNotificationsOn, false);
    expect(settings.areLossOfDaysNotificationsOn, false);
  });

  test('load notifications settings, not all params given', () async {
    when(() => fireSettingsService.loadNotificationsSettings()).thenAnswer(
      (_) async => NotificationsSettingsDbModel(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
      ),
    );

    try {
      await fireSettingsRepository.loadNotificationsSettings();
    } catch (error) {
      verify(() => fireSettingsService.loadNotificationsSettings()).called(1);
      expect(error, 'Cannot load one of the notifications settings.');
    }
  });

  test('update appearance settings', () async {
    when(() => fireSettingsService.updateAppearanceSettings(isDarkModeOn: true))
        .thenAnswer((_) async => '');

    await fireSettingsRepository.updateAppearanceSettings(isDarkModeOn: true);

    verify(
      () => fireSettingsService.updateAppearanceSettings(isDarkModeOn: true),
    ).called(1);
  });

  test('update notifications settings', () async {
    when(() => fireSettingsService.updateNotificationsSettings(
          areSessionsPlannedNotificationsOn: true,
          areAchievementsNotificationsOn: true,
        )).thenAnswer((_) async => '');

    await fireSettingsRepository.updateNotificationsSettings(
      areSessionsPlannedNotificationsOn: true,
      areAchievementsNotificationsOn: true,
    );

    verify(
      () => fireSettingsService.updateNotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areAchievementsNotificationsOn: true,
      ),
    ).called(1);
  });
}
