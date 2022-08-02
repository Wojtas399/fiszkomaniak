import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import '../../../domain/use_cases/appearance_settings/load_appearance_settings_use_case.dart';
import '../../../domain/use_cases/groups/load_all_groups_use_case.dart';
import '../../../domain/use_cases/notifications_settings/load_notifications_settings_use_case.dart';
import '../../../domain/use_cases/notifications/initialize_notifications_settings_use_case.dart';
import '../../../domain/use_cases/user/get_days_streak_use_case.dart';
import '../../../domain/use_cases/user/get_user_avatar_url_use_case.dart';
import '../../../domain/use_cases/user/load_user_use_case.dart';
import '../../../domain/entities/appearance_settings.dart';
import '../../../models/bloc_status.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final LoadUserUseCase _loadUserUseCase;
  late final LoadAllGroupsUseCase _loadAllGroupsUseCase;
  late final LoadAppearanceSettingsUseCase _loadAppearanceSettingsUseCase;
  late final LoadNotificationsSettingsUseCase _loadNotificationsSettingsUseCase;
  late final InitializeNotificationsSettingsUseCase
      _initializeNotificationsSettingsUseCase;
  late final GetUserAvatarUrlUseCase _getUserAvatarUrlUseCase;
  late final GetAppearanceSettingsUseCase _getAppearanceSettingsUseCase;
  late final GetDaysStreakUseCase _getDaysStreakUseCase;
  StreamSubscription<HomeStateListenedParams>? _paramsListener;

  HomeBloc({
    required LoadUserUseCase loadUserUseCase,
    required LoadAllGroupsUseCase loadAllGroupsUseCase,
    required LoadAppearanceSettingsUseCase loadAppearanceSettingsUseCase,
    required LoadNotificationsSettingsUseCase loadNotificationsSettingsUseCase,
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
    _loadAppearanceSettingsUseCase = loadAppearanceSettingsUseCase;
    _loadNotificationsSettingsUseCase = loadNotificationsSettingsUseCase;
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
      await _loadUserUseCase.execute();
      await _loadAllGroupsUseCase.execute();
      await _loadAppearanceSettingsUseCase.execute();
      await _loadNotificationsSettingsUseCase.execute();
      await _initializeNotificationsSettingsUseCase.execute();
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
