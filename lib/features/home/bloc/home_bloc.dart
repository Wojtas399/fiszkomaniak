import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/settings.dart';
import '../../../domain/use_cases/groups/load_all_groups_use_case.dart';
import '../../../domain/use_cases/notifications/initialize_notifications_settings_use_case.dart';
import '../../../domain/use_cases/settings/get_appearance_settings_use_case.dart';
import '../../../domain/use_cases/settings/load_settings_use_case.dart';
import '../../../domain/use_cases/user/get_days_streak_use_case.dart';
import '../../../domain/use_cases/user/get_user_avatar_url_use_case.dart';
import '../../../domain/use_cases/user/load_user_use_case.dart';
import '../../../domain/use_cases/sessions/load_all_sessions_use_case.dart';
import '../../../models/bloc_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final LoadUserUseCase _loadUserUseCase;
  late final LoadAllGroupsUseCase _loadAllGroupsUseCase;
  late final LoadAllSessionsUseCase _loadAllSessionsUseCase;
  late final LoadSettingsUseCase _loadSettingsUseCase;
  late final InitializeNotificationsSettingsUseCase
      _initializeNotificationsSettingsUseCase;
  late final GetUserAvatarUrlUseCase _getUserAvatarUrlUseCase;
  late final GetAppearanceSettingsUseCase _getAppearanceSettingsUseCase;
  late final GetDaysStreakUseCase _getDaysStreakUseCase;
  StreamSubscription<HomeStateListenedParams>? _paramsListener;

  HomeBloc({
    required LoadUserUseCase loadUserUseCase,
    required LoadAllGroupsUseCase loadAllGroupsUseCase,
    required LoadAllSessionsUseCase loadAllSessionsUseCase,
    required LoadSettingsUseCase loadSettingsUseCase,
    required InitializeNotificationsSettingsUseCase
        initializeNotificationsSettingsUseCase,
    required GetUserAvatarUrlUseCase getUserAvatarUrlUseCase,
    required GetAppearanceSettingsUseCase getAppearanceSettingsUseCase,
    required GetDaysStreakUseCase getDaysStreakUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String loggedUserAvatarUrl = '',
    bool isDarkModeOn = false,
    bool isDarkModeCompatibilityWithSystemOn = false,
    int daysStreak = 0,
  }) : super(
          HomeState(
            status: status,
            loggedUserAvatarUrl: loggedUserAvatarUrl,
            isDarkModeOn: isDarkModeOn,
            isDarkModeCompatibilityWithSystemOn:
                isDarkModeCompatibilityWithSystemOn,
            daysStreak: daysStreak,
          ),
        ) {
    _loadUserUseCase = loadUserUseCase;
    _loadAllGroupsUseCase = loadAllGroupsUseCase;
    _loadAllSessionsUseCase = loadAllSessionsUseCase;
    _loadSettingsUseCase = loadSettingsUseCase;
    _initializeNotificationsSettingsUseCase =
        initializeNotificationsSettingsUseCase;
    _getUserAvatarUrlUseCase = getUserAvatarUrlUseCase;
    _getAppearanceSettingsUseCase = getAppearanceSettingsUseCase;
    _getDaysStreakUseCase = getDaysStreakUseCase;
    on<HomeEventInitialize>(_initialize);
    on<HomeEventListenedParamsUpdated>(_listenedParamsUpdated);
  }

  @override
  Future<void> close() {
    _paramsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: const BlocStatusLoading()));
      await _loadData().timeout(const Duration(seconds: 6));
      emit(state.copyWith(status: const BlocStatusComplete()));
      _setParamsListener();
    } catch (_) {
      emit(state.copyWith(status: const BlocStatusError()));
    }
  }

  void _listenedParamsUpdated(
    HomeEventListenedParamsUpdated event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      loggedUserAvatarUrl: event.params.loggedUserAvatarUrl,
      isDarkModeOn: event.params.appearanceSettings.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.params.appearanceSettings.isDarkModeCompatibilityWithSystemOn,
      daysStreak: event.params.daysStreak,
    ));
  }

  Future<void> _loadData() async {
    await _loadUserUseCase.execute();
    await _loadAllGroupsUseCase.execute();
    await _loadAllSessionsUseCase.execute();
    await _loadSettingsUseCase.execute();
    await _initializeNotificationsSettingsUseCase.execute();
  }

  void _setParamsListener() {
    _paramsListener ??= Rx.combineLatest3(
      _getUserAvatarUrlUseCase.execute(),
      _getAppearanceSettingsUseCase.execute(),
      _getDaysStreakUseCase.execute(),
      (
        String? userAvatarUrl,
        AppearanceSettings appearanceSettings,
        int daysStreak,
      ) =>
          HomeStateListenedParams(
        loggedUserAvatarUrl: userAvatarUrl,
        appearanceSettings: appearanceSettings,
        daysStreak: daysStreak,
      ),
    ).listen(
      (HomeStateListenedParams params) => add(
        HomeEventListenedParamsUpdated(params: params),
      ),
    );
  }
}
