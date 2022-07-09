import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/load_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/load_all_groups_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/load_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/appearance_settings.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_status.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final UserInterface _userInterface;
  late final LoadAllGroupsUseCase _loadAllGroupsUseCase;
  late final LoadAppearanceSettingsUseCase _loadAppearanceSettingsUseCase;
  late final LoadNotificationsSettingsUseCase _loadNotificationsSettingsUseCase;
  late final GetAppearanceSettingsUseCase _getAppearanceSettingsUseCase;
  StreamSubscription<String>? _loggedUserAvatarUrlListener;
  StreamSubscription<AppearanceSettings>? _appearanceSettingsListener;

  HomeBloc({
    required UserInterface userInterface,
    required LoadAllGroupsUseCase loadAllGroupsUseCase,
    required LoadAppearanceSettingsUseCase loadAppearanceSettingsUseCase,
    required LoadNotificationsSettingsUseCase loadNotificationsSettingsUseCase,
    required GetAppearanceSettingsUseCase getAppearanceSettingsUseCase,
  }) : super(const HomeState()) {
    _userInterface = userInterface;
    _loadAllGroupsUseCase = loadAllGroupsUseCase;
    _loadAppearanceSettingsUseCase = loadAppearanceSettingsUseCase;
    _loadNotificationsSettingsUseCase = loadNotificationsSettingsUseCase;
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
    _setLoggedUserAvatarUrlListener();
    _setAppearanceSettingsListener();
    try {
      emit(state.copyWith(status: HomeStatusLoading()));
      await _userInterface.loadLoggedUserAvatar();
      await _loadAllGroupsUseCase.execute();
      await _loadAppearanceSettingsUseCase.execute();
      await _loadNotificationsSettingsUseCase.execute();
      emit(state.copyWith(status: HomeStatusLoaded()));
    } catch (error) {
      emit(state.copyWith(
        status: HomeStatusError(message: error.toString()),
      ));
    }
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
    _loggedUserAvatarUrlListener = _userInterface.loggedUserAvatarUrl$.listen(
      (avatarUrl) => add(
        HomeEventLoggedUserAvatarUrlUpdated(newLoggedUserAvatarUrl: avatarUrl),
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
