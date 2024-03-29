import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/settings.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/load_all_groups_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/settings/load_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications/initialize_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_days_streak_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/get_user_avatar_url_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/user/load_user_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/load_all_sessions_use_case.dart';
import 'package:fiszkomaniak/features/home/bloc/home_bloc.dart';
import 'package:fiszkomaniak/models/bloc_status.dart';

class MockLoadUserUserCase extends Mock implements LoadUserUseCase {}

class MockLoadAllGroupsUseCase extends Mock implements LoadAllGroupsUseCase {}

class MockLoadAllSessionsUseCase extends Mock
    implements LoadAllSessionsUseCase {}

class MockLoadSettingsUseCase extends Mock implements LoadSettingsUseCase {}

class MockInitializeNotificationsSettingsUseCase extends Mock
    implements InitializeNotificationsSettingsUseCase {}

class MockGetUserAvatarUrlUseCase extends Mock
    implements GetUserAvatarUrlUseCase {}

class MockGetAppearanceSettingsUseCase extends Mock
    implements GetAppearanceSettingsUseCase {}

class MockGetDaysStreakUseCase extends Mock implements GetDaysStreakUseCase {}

void main() {
  final loadUserUseCase = MockLoadUserUserCase();
  final loadAllGroupsUseCase = MockLoadAllGroupsUseCase();
  final loadAllSessionsUseCase = MockLoadAllSessionsUseCase();
  final loadSettingsUseCase = MockLoadSettingsUseCase();
  final initializeNotificationsSettingsUseCase =
      MockInitializeNotificationsSettingsUseCase();
  final getUserAvatarUrlUseCase = MockGetUserAvatarUrlUseCase();
  final getAppearanceSettingsUseCase = MockGetAppearanceSettingsUseCase();
  final getDaysStreakUseCase = MockGetDaysStreakUseCase();
  const String userAvatarUrl = 'avatar/url';
  const AppearanceSettings appearanceSettings = AppearanceSettings(
    isDarkModeOn: false,
    isDarkModeCompatibilityWithSystemOn: true,
    isSessionTimerInvisibilityOn: false,
  );
  const int daysStreak = 12;

  HomeBloc createBloc() {
    return HomeBloc(
      loadUserUseCase: loadUserUseCase,
      loadAllGroupsUseCase: loadAllGroupsUseCase,
      loadAllSessionsUseCase: loadAllSessionsUseCase,
      loadSettingsUseCase: loadSettingsUseCase,
      initializeNotificationsSettingsUseCase:
          initializeNotificationsSettingsUseCase,
      getUserAvatarUrlUseCase: getUserAvatarUrlUseCase,
      getAppearanceSettingsUseCase: getAppearanceSettingsUseCase,
      getDaysStreakUseCase: getDaysStreakUseCase,
    );
  }

  HomeState createState({
    BlocStatus status = const BlocStatusComplete(),
    String loggedUserAvatarUrl = '',
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
    int daysStreak = 0,
  }) {
    return HomeState(
      status: status,
      loggedUserAvatarUrl: loggedUserAvatarUrl,
      isDarkModeOn: isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn: isDarkModeCompatibilityWithSystemOn,
      daysStreak: daysStreak,
    );
  }

  tearDown(() {
    reset(loadUserUseCase);
    reset(loadAllGroupsUseCase);
    reset(loadAllSessionsUseCase);
    reset(loadSettingsUseCase);
    reset(getUserAvatarUrlUseCase);
    reset(getAppearanceSettingsUseCase);
    reset(getDaysStreakUseCase);
  });

  group(
    'initialize',
    () {
      setUp(() {
        when(
          () => loadUserUseCase.execute(),
        ).thenAnswer((_) async => '');
        when(
          () => loadAllGroupsUseCase.execute(),
        ).thenAnswer((_) async => '');
        when(
          () => loadAllSessionsUseCase.execute(),
        ).thenAnswer((_) async => '');
        when(
          () => loadSettingsUseCase.execute(),
        ).thenAnswer((_) async => '');
        when(
          () => initializeNotificationsSettingsUseCase.execute(),
        ).thenAnswer((_) async => '');
        when(
          () => getUserAvatarUrlUseCase.execute(),
        ).thenAnswer((_) => Stream.value(userAvatarUrl));
        when(
          () => getAppearanceSettingsUseCase.execute(),
        ).thenAnswer((_) => Stream.value(appearanceSettings));
        when(
          () => getDaysStreakUseCase.execute(),
        ).thenAnswer((_) => Stream.value(daysStreak));
      });

      blocTest(
        'should call use cases responsible for loading user, all groups, all sessions and settings, use case responsible for initializing notifications settings and should set params listener',
        build: () => createBloc(),
        act: (HomeBloc bloc) {
          bloc.add(HomeEventInitialize());
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(status: const BlocStatusComplete()),
          createState(
            loggedUserAvatarUrl: userAvatarUrl,
            isDarkModeOn: appearanceSettings.isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                appearanceSettings.isDarkModeCompatibilityWithSystemOn,
            daysStreak: daysStreak,
          ),
        ],
        verify: (_) {
          verify(
            () => loadUserUseCase.execute(),
          ).called(1);
          verify(
            () => loadAllGroupsUseCase.execute(),
          ).called(1);
          verify(
            () => loadAllSessionsUseCase.execute(),
          ).called(1);
          verify(
            () => loadSettingsUseCase.execute(),
          ).called(1);
          verify(
            () => initializeNotificationsSettingsUseCase.execute(),
          ).called(1);
        },
      );

      blocTest(
        'should emit error if one of use cases responsible for loading data or initializing settings throws error',
        build: () => createBloc(),
        setUp: () {
          when(
            () => loadSettingsUseCase.execute(),
          ).thenThrow('');
        },
        act: (HomeBloc bloc) {
          bloc.add(HomeEventInitialize());
        },
        expect: () => [
          createState(status: const BlocStatusLoading()),
          createState(status: const BlocStatusError()),
        ],
        verify: (_) {
          verify(
            () => loadUserUseCase.execute(),
          ).called(1);
          verify(
            () => loadAllGroupsUseCase.execute(),
          ).called(1);
          verify(
            () => loadAllSessionsUseCase.execute(),
          ).called(1);
          verify(
            () => loadSettingsUseCase.execute(),
          ).called(1);
          verifyNever(
            () => initializeNotificationsSettingsUseCase.execute(),
          );
        },
      );
    },
  );

  blocTest(
    'listened params updated, should update in state logged user avatar url, dark mode status, dark mode compatibility with system status and days streak',
    build: () => createBloc(),
    act: (HomeBloc bloc) {
      bloc.add(
        HomeEventListenedParamsUpdated(
          params: const HomeStateListenedParams(
            loggedUserAvatarUrl: userAvatarUrl,
            appearanceSettings: appearanceSettings,
            daysStreak: daysStreak,
          ),
        ),
      );
    },
    expect: () => [
      createState(
        loggedUserAvatarUrl: userAvatarUrl,
        isDarkModeOn: appearanceSettings.isDarkModeOn,
        isDarkModeCompatibilityWithSystemOn:
            appearanceSettings.isDarkModeCompatibilityWithSystemOn,
        daysStreak: daysStreak,
      ),
    ],
  );
}
