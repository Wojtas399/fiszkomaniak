import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/settings/appearance_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSettingsInterface extends Mock implements SettingsInterface {}

void main() {
  final SettingsInterface settingsInterface = MockSettingsInterface();
  late AppearanceSettingsBloc appearanceSettingsBloc;

  setUp(() {
    appearanceSettingsBloc = AppearanceSettingsBloc(
      settingsInterface: settingsInterface,
    );
  });

  tearDown(() {
    reset(settingsInterface);
  });

  blocTest(
    'load, success',
    build: () => appearanceSettingsBloc,
    setUp: () {
      when(() => settingsInterface.loadAppearanceSettings()).thenAnswer(
        (_) async => const AppearanceSettings(
          isDarkModeOn: true,
          isDarkModeCompatibilityWithSystemOn: false,
          isSessionTimerInvisibilityOn: false,
        ),
      );
    },
    act: (AppearanceSettingsBloc bloc) => bloc.add(
      AppearanceSettingsEventLoad(),
    ),
    expect: () => [
      const AppearanceSettingsState(
        initializationStatus: InitializationStatus.ready,
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
        httpStatus: HttpStatusSuccess(),
      ),
    ],
    verify: (_) {
      verify(() => settingsInterface.loadAppearanceSettings()).called(1);
    },
  );

  blocTest(
    'load, failure',
    build: () => appearanceSettingsBloc,
    setUp: () {
      when(() => settingsInterface.loadAppearanceSettings()).thenThrow(
        'Error...',
      );
    },
    act: (AppearanceSettingsBloc bloc) => bloc.add(
      AppearanceSettingsEventLoad(),
    ),
    expect: () => [
      const AppearanceSettingsState(
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
    verify: (_) {
      verify(() => settingsInterface.loadAppearanceSettings()).called(1);
    },
  );

  blocTest(
    'update, success',
    build: () => appearanceSettingsBloc,
    setUp: () {
      when(() => settingsInterface.updateAppearanceSettings(isDarkModeOn: true))
          .thenAnswer((_) async => '');
    },
    act: (AppearanceSettingsBloc bloc) => bloc.add(
      AppearanceSettingsEventUpdate(isDarkModeOn: true),
    ),
    expect: () => [
      const AppearanceSettingsState(isDarkModeOn: true),
    ],
    verify: (_) {
      verify(
        () => settingsInterface.updateAppearanceSettings(isDarkModeOn: true),
      ).called(1);
    },
  );

  blocTest(
    'update, failure',
    build: () => appearanceSettingsBloc,
    setUp: () {
      when(() => settingsInterface.updateAppearanceSettings(isDarkModeOn: true))
          .thenThrow('Error...');
    },
    act: (AppearanceSettingsBloc bloc) => bloc.add(
      AppearanceSettingsEventUpdate(isDarkModeOn: true),
    ),
    expect: () => [
      const AppearanceSettingsState(isDarkModeOn: true),
      const AppearanceSettingsState(
        isDarkModeOn: false,
        httpStatus: HttpStatusFailure(message: 'Error...'),
      ),
    ],
    verify: (_) {
      verify(
        () => settingsInterface.updateAppearanceSettings(isDarkModeOn: true),
      ).called(1);
    },
  );
}
