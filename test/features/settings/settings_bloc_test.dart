import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/get_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/update_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}

class MockUpdateAppearanceSettingsUseCase extends Mock
    implements UpdateAppearanceSettingsUseCase {}

class MockUpdateNotificationsSettingsUseCase extends Mock
    implements UpdateNotificationsSettingsUseCase {}

void main() {
  final getSettingsUseCase = MockGetSettingsUseCase();
  final updateAppearanceSettingsUseCase = MockUpdateAppearanceSettingsUseCase();
  final updateNotificationsSettingsUseCase =
      MockUpdateNotificationsSettingsUseCase();

  SettingsBloc createBloc({
    Settings settings = const Settings(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
      notificationsSettings: NotificationsSettings(
        areSessionsScheduledNotificationsOn: false,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: false,
      ),
    ),
    bool areAllNotificationsOn = false,
  }) {
    return SettingsBloc(
      getSettingsUseCase: getSettingsUseCase,
      updateAppearanceSettingsUseCase: updateAppearanceSettingsUseCase,
      updateNotificationsSettingsUseCase: updateNotificationsSettingsUseCase,
      settings: settings,
      areAllNotificationsOn: areAllNotificationsOn,
    );
  }

  SettingsState createState({
    Settings settings = const Settings(
      appearanceSettings: AppearanceSettings(
        isDarkModeOn: false,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: false,
      ),
      notificationsSettings: NotificationsSettings(
        areSessionsScheduledNotificationsOn: false,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: false,
        areLossOfDaysStreakNotificationsOn: false,
      ),
    ),
    bool areAllNotificationsOn = false,
  }) {
    return SettingsState(
      settings: settings,
      areAllNotificationsOn: areAllNotificationsOn,
    );
  }

  tearDown(
    () {
      reset(getSettingsUseCase);
      reset(updateAppearanceSettingsUseCase);
      reset(updateNotificationsSettingsUseCase);
    },
  );

  group(
    'initialize',
    () {
      final Settings settings = createSettings(
        appearanceSettings: createAppearanceSettings(
          isDarkModeOn: true,
        ),
        notificationsSettings: createNotificationsSettings(
          areSessionsScheduledNotificationsOn: true,
          areSessionsDefaultNotificationsOn: true,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      );

      blocTest(
        'should set settings listener',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getSettingsUseCase.execute(),
          ).thenAnswer((_) => Stream.value(settings));
        },
        act: (SettingsBloc bloc) {
          bloc.add(SettingsEventInitialize());
        },
        expect: () => [
          createState(
            settings: settings,
            areAllNotificationsOn: true,
          ),
        ],
        verify: (_) {
          verify(() => getSettingsUseCase.execute()).called(1);
        },
      );
    },
  );

  group(
    'settings updated',
    () {
      final Settings settings = createSettings(
        appearanceSettings: createAppearanceSettings(
          isDarkModeOn: true,
        ),
        notificationsSettings: createNotificationsSettings(
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      );

      blocTest(
        'should update settings in state',
        build: () => createBloc(),
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventSettingsUpdated(settings: settings),
          );
        },
        expect: () => [
          createState(
            settings: settings,
          ),
        ],
      );
    },
  );

  blocTest(
    'appearance settings changed,should call method responsible for updating appearance settings',
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
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventAppearanceSettingsChanged(
          isDarkModeOn: false,
          isDarkModeCompatibilityWithSystemOn: true,
          isSessionTimerInvisibilityOn: false,
        ),
      );
    },
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

  blocTest(
    'notifications settings changed, should call method responsible for updating notifications settings',
    build: () => createBloc(),
    setUp: () {
      when(
        () => updateNotificationsSettingsUseCase.execute(
          areSessionsScheduledNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventNotificationsSettingsChanged(
          areSessionsScheduledNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      );
    },
    verify: (_) {
      verify(
        () => updateNotificationsSettingsUseCase.execute(
          areSessionsScheduledNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      ).called(1);
    },
  );
}
