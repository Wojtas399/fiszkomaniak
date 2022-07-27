import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import '../../../domain/use_cases/appearance_settings/load_appearance_settings_use_case.dart';
import '../../../domain/use_cases/groups/load_all_groups_use_case.dart';
import '../../../domain/use_cases/notifications_settings/load_notifications_settings_use_case.dart';
import '../../../domain/use_cases/user/get_user_avatar_url_use_case.dart';
import '../../../domain/use_cases/user/load_user_use_case.dart';
import '../../../domain/entities/appearance_settings.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_status.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final LoadUserUseCase _loadUserUseCase;
  late final LoadAllGroupsUseCase _loadAllGroupsUseCase;
  late final LoadAppearanceSettingsUseCase _loadAppearanceSettingsUseCase;
  late final LoadNotificationsSettingsUseCase _loadNotificationsSettingsUseCase;
  late final GetUserAvatarUrlUseCase _getUserAvatarUrlUseCase;
  late final GetAppearanceSettingsUseCase _getAppearanceSettingsUseCase;
  StreamSubscription<String>? _loggedUserAvatarUrlListener;
  StreamSubscription<AppearanceSettings>? _appearanceSettingsListener;

  HomeBloc({
    required LoadUserUseCase loadUserUseCase,
    required LoadAllGroupsUseCase loadAllGroupsUseCase,
    required LoadAppearanceSettingsUseCase loadAppearanceSettingsUseCase,
    required LoadNotificationsSettingsUseCase loadNotificationsSettingsUseCase,
    required GetUserAvatarUrlUseCase getUserAvatarUrlUseCase,
    required GetAppearanceSettingsUseCase getAppearanceSettingsUseCase,
  }) : super(const HomeState()) {
    _loadUserUseCase = loadUserUseCase;
    _loadAllGroupsUseCase = loadAllGroupsUseCase;
    _loadAppearanceSettingsUseCase = loadAppearanceSettingsUseCase;
    _loadNotificationsSettingsUseCase = loadNotificationsSettingsUseCase;
    _getUserAvatarUrlUseCase = getUserAvatarUrlUseCase;
    _getAppearanceSettingsUseCase = getAppearanceSettingsUseCase;
    on<HomeEventInitialize>(_initialize);
    on<HomeEventLoggedUserAvatarUrlUpdated>(_loggedUserAvatarUrlUpdated);
    on<HomeEventAppearanceSettingsUpdated>(_appearanceSettingsUpdated);
  }

  @override
  Future<void> close() {
    _loggedUserAvatarUrlListener?.cancel();
    _appearanceSettingsListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(status: HomeStatusLoading()));
      await _loadUserUseCase.execute();
      await _loadAllGroupsUseCase.execute();
      await _loadAppearanceSettingsUseCase.execute();
      await _loadNotificationsSettingsUseCase.execute();
      emit(state.copyWith(status: HomeStatusLoaded()));
    } catch (error) {
      emit(state.copyWith(
        status: HomeStatusError(message: error.toString()),
      ));
    }
    _setLoggedUserAvatarUrlListener();
    _setAppearanceSettingsListener();
  }

  void _loggedUserAvatarUrlUpdated(
    HomeEventLoggedUserAvatarUrlUpdated event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      loggedUserAvatarUrl: event.newLoggedUserAvatarUrl,
    ));
  }

  void _appearanceSettingsUpdated(
    HomeEventAppearanceSettingsUpdated event,
    Emitter<HomeState> emit,
  ) {
    emit(state.copyWith(
      isDarkModeOn: event.appearanceSettings.isDarkModeOn,
      isDarkModeCompatibilityWithSystemOn:
          event.appearanceSettings.isDarkModeCompatibilityWithSystemOn,
    ));
  }

  void _setLoggedUserAvatarUrlListener() {
    _loggedUserAvatarUrlListener =
        _getUserAvatarUrlUseCase.execute().whereType<String>().listen(
              (avatarUrl) => add(
                HomeEventLoggedUserAvatarUrlUpdated(
                    newLoggedUserAvatarUrl: avatarUrl),
              ),
            );
  }

  void _setAppearanceSettingsListener() {
    _appearanceSettingsListener = _getAppearanceSettingsUseCase
        .execute()
        .listen(
          (settings) => add(
            HomeEventAppearanceSettingsUpdated(appearanceSettings: settings),
          ),
        );
  }
}
