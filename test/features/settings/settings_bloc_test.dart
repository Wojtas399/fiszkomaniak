import 'package:bloc_test/bloc_test.dart';
import 'package:fiszkomaniak/domain/entities/appearance_settings.dart';
import 'package:fiszkomaniak/domain/entities/notifications_settings.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/get_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/update_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAppearanceSettingsUseCase extends Mock
    implements GetAppearanceSettingsUseCase {}

class MockGetNotificationsSettingsUseCase extends Mock
    implements GetNotificationsSettingsUseCase {}

class MockUpdateAppearanceSettingsUseCase extends Mock
    implements UpdateAppearanceSettingsUseCase {}

class MockUpdateNotificationsSettingsUseCase extends Mock
    implements UpdateNotificationsSettingsUseCase {}

void main() {
  final getAppearanceSettingsUseCase = MockGetAppearanceSettingsUseCase();
  final getNotificationsSettingsUseCase = MockGetNotificationsSettingsUseCase();
  final updateAppearanceSettingsUseCase = MockUpdateAppearanceSettingsUseCase();
  final updateNotificationsSettingsUseCase =
      MockUpdateNotificationsSettingsUseCase();

  SettingsBloc createBloc({
    AppearanceSettings appearanceSettings = const AppearanceSettings(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: false,
    ),
    NotificationsSettings notificationsSettings = const NotificationsSettings(
      areSessionsPlannedNotificationsOn: false,
      areSessionsDefaultNotificationsOn: false,
      areAchievementsNotificationsOn: false,
      areLossOfDaysStreakNotificationsOn: false,
    ),
    bool areAllNotificationsOn = false,
  }) {
    return SettingsBloc(
      getAppearanceSettingsUseCase: getAppearanceSettingsUseCase,
      getNotificationsSettingsUseCase: getNotificationsSettingsUseCase,
      updateAppearanceSettingsUseCase: updateAppearanceSettingsUseCase,
      updateNotificationsSettingsUseCase: updateNotificationsSettingsUseCase,
      appearanceSettings: appearanceSettings,
      notificationsSettings: notificationsSettings,
      areAllNotificationsOn: areAllNotificationsOn,
    );
  }

  SettingsState createState({
    AppearanceSettings appearanceSettings = const AppearanceSettings(
      isDarkModeOn: false,
      isDarkModeCompatibilityWithSystemOn: false,
      isSessionTimerInvisibilityOn: false,
    ),
    NotificationsSettings notificationsSettings = const NotificationsSettings(
      areSessionsPlannedNotificationsOn: false,
      areSessionsDefaultNotificationsOn: false,
      areAchievementsNotificationsOn: false,
      areLossOfDaysStreakNotificationsOn: false,
    ),
    bool areAllNotificationsOn = false,
  }) {
    return SettingsState(
      appearanceSettings: appearanceSettings,
      notificationsSettings: notificationsSettings,
      areAllNotificationsOn: areAllNotificationsOn,
    );
  }

  tearDown(
    () {
      reset(getAppearanceSettingsUseCase);
      reset(getNotificationsSettingsUseCase);
      reset(updateAppearanceSettingsUseCase);
      reset(updateNotificationsSettingsUseCase);
    },
  );

  group(
    'appearance settings updated',
    () {
      const AppearanceSettings appearanceSettings = AppearanceSettings(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: true,
      );

      blocTest(
        'should update appearance settings in state',
        build: () => createBloc(),
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventAppearanceSettingsUpdated(
              appearanceSettings: appearanceSettings,
            ),
          );
        },
        expect: () => [
          createState(
            appearanceSettings: appearanceSettings,
          ),
        ],
      );
    },
  );

  group(
    'notifications settings updated',
    () {
      const NotificationsSettings notificationsSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: false,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: false,
      );

      blocTest(
        'should update notifications settings in state',
        build: () => createBloc(),
        act: (SettingsBloc bloc) {
          bloc.add(
            SettingsEventNotificationsSettingsUpdated(
              notificationsSettings: notificationsSettings,
            ),
          );
        },
        expect: () => [
          createState(
            notificationsSettings: notificationsSettings,
          ),
        ],
      );
    },
  );

  group(
    'initialize',
    () {
      const AppearanceSettings appearanceSettings = AppearanceSettings(
        isDarkModeOn: true,
        isDarkModeCompatibilityWithSystemOn: false,
        isSessionTimerInvisibilityOn: true,
      );
      const NotificationsSettings notificationsSettings = NotificationsSettings(
        areSessionsPlannedNotificationsOn: true,
        areSessionsDefaultNotificationsOn: true,
        areAchievementsNotificationsOn: true,
        areLossOfDaysStreakNotificationsOn: true,
      );

      blocTest(
        'should update all settings in state and should set appearance and notifications settings listeners',
        build: () => createBloc(),
        setUp: () {
          when(
            () => getAppearanceSettingsUseCase.execute(),
          ).thenAnswer((_) => Stream.value(appearanceSettings));
          when(
            () => getNotificationsSettingsUseCase.execute(),
          ).thenAnswer((_) => Stream.value(notificationsSettings));
        },
        act: (SettingsBloc bloc) {
          bloc.add(SettingsEventInitialize());
        },
        expect: () => [
          createState(
            appearanceSettings: appearanceSettings,
          ),
          createState(
            appearanceSettings: appearanceSettings,
            notificationsSettings: notificationsSettings,
            areAllNotificationsOn: true,
          ),
        ],
        verify: (_) {
          verify(() => getAppearanceSettingsUseCase.execute()).called(1);
          verify(() => getNotificationsSettingsUseCase.execute()).called(1);
        },
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
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      ).thenAnswer((_) async => '');
    },
    act: (SettingsBloc bloc) {
      bloc.add(
        SettingsEventNotificationsSettingsChanged(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      );
    },
    verify: (_) {
      verify(
        () => updateNotificationsSettingsUseCase.execute(
          areSessionsPlannedNotificationsOn: false,
          areSessionsDefaultNotificationsOn: false,
          areAchievementsNotificationsOn: true,
          areLossOfDaysStreakNotificationsOn: true,
        ),
      ).called(1);
    },
  );
}
