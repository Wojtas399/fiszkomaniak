import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/repositories/appearance_settings_repository.dart';
import 'package:fiszkomaniak/firebase/models/appearance_settings_db_model.dart';
import 'package:fiszkomaniak/firebase/services/fire_appearance_settings_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFireAppearanceSettingsService extends Mock
    implements FireAppearanceSettingsService {}

void main() {
  final fireAppearanceSettingsService = MockFireAppearanceSettingsService();
  late AppearanceSettingsRepository repository;

  setUp(
    () => repository = AppearanceSettingsRepository(
      fireAppearanceSettingsService: fireAppearanceSettingsService,
    ),
  );

  tearDown(() {
    reset(fireAppearanceSettingsService);
  });

  test(
    'set default settings, should call method responsible for setting default appearance settings',
    () async {
      when(
        () => fireAppearanceSettingsService.setDefaultSettings(),
      ).thenAnswer((_) async => '');

      await repository.setDefaultSettings();

      verify(
        () => fireAppearanceSettingsService.setDefaultSettings(),
      ).called(1);
    },
  );

  test(
    'load settings, should load appearance settings and add them to stream',
    () async {
      final dbAppearanceSettings = AppearanceSettingsDbModel(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: true,
      );
      const appearanceSettings = AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: true,
      );
      when(
        () => fireAppearanceSettingsService.loadSettings(),
      ).thenAnswer((_) async => dbAppearanceSettings);

      await repository.loadSettings();

      expect(
        await repository.appearanceSettings$.first,
        appearanceSettings,
      );
    },
  );

  test(
    'load settings, should throw error if one of parameters does not have value',
    () async {
      final AppearanceSettingsDbModel dbAppearanceSettings =
          AppearanceSettingsDbModel(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: null,
        isSessionTimerInvisibilityOn: true,
      );
      when(
        () => fireAppearanceSettingsService.loadSettings(),
      ).thenAnswer((_) async => dbAppearanceSettings);

      try {
        await repository.loadSettings();
      } catch (error) {
        expect(error, 'Cannot load one of the appearance settings.');
      }
    },
  );

  test(
    'update settings, should call method responsible for updating settings',
    () async {
      when(
        () => fireAppearanceSettingsService.updateSettings(
          isDarkModeOn: true,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      ).thenAnswer((_) async => '');

      await repository.updateSettings(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: true,
        isSessionTimerInvisibilityOn: false,
      );

      verify(
        () => fireAppearanceSettingsService.updateSettings(
          isDarkModeOn: true,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      ).called(1);
    },
  );
}
