import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAppearanceSettingsUseCase extends Mock
    implements GetAppearanceSettingsUseCase {}

class MockUpdateAppearanceSettingsUseCase extends Mock
    implements UpdateAppearanceSettingsUseCase {}

void main() {
  final getAppearanceSettingsUseCase = MockGetAppearanceSettingsUseCase();
  final updateAppearanceSettingsUseCase = MockUpdateAppearanceSettingsUseCase();

  AppearanceSettingsBloc createBloc({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) {
    return AppearanceSettingsBloc(
      getAppearanceSettingsUseCase: getAppearanceSettingsUseCase,
      updateAppearanceSettingsUseCase: updateAppearanceSettingsUseCase,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn,
    );
  }

  AppearanceSettingsState createState({
    bool? isDarkModeOn,
    bool? isDarkModeCompatibilityWithSystemOn,
    bool? isSessionTimerInvisibilityOn,
  }) {
    return AppearanceSettingsState(
      isDarkModeOn: isDarkModeOn ?? false,
      isDarkModeCompatibilityWithSystemOn:
          isDarkModeCompatibilityWithSystemOn ?? false,
      isSessionTimerInvisibilityOn: isSessionTimerInvisibilityOn ?? false,
    );
  }

  group(
    'load',
    () {
      const AppearanceSettings appearanceSettings = AppearanceSettings(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: true,
      );

      blocTest(
        'should get appearance settings and assign them to state',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getAppearanceSettingsUseCase.execute(),
          ).thenAnswer((_) => Stream.value(appearanceSettings));
        },
        act: (AppearanceSettingsBloc bloc) {
          bloc.add(AppearanceSettingsEventLoad());
        },
        expect: () => [
          createState(
            isDarkModeOn: appearanceSettings.isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                appearanceSettings.isDarkModeCompatibilityWithSystemOn,
            isSessionTimerInvisibilityOn:
                appearanceSettings.isSessionTimerInvisibilityOn,
          ),
        ],
        verify: (_) {
          verify(() => getAppearanceSettingsUseCase.execute()).called(1);
        },
      );
    },
  );

  blocTest(
    'update, should update state firstly and then should call use case responsible for updating appearance settings',
    build: () => createBloc(),
    setUp: () {
      when(
        () => updateAppearanceSettingsUseCase.execute(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (AppearanceSettingsBloc bloc) {
      bloc.add(
        AppearanceSettingsEventUpdate(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      );
    },
    expect: () => [
      createState(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: true,
        isSessionTimerInvisibilityOn: false,
      ),
    ],
    verify: (_) {
      verify(
        () => updateAppearanceSettingsUseCase.execute(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      ).called(1);
    },
  );
}
