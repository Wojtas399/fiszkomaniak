import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../interfaces/groups_interface.dart';

part 'home_event.dart';

part 'home_state.dart';

part 'home_status.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  late final UserInterface _userInterface;
  late final GroupsInterface _groupsInterface;
  StreamSubscription<String>? _loggedUserAvatarUrlListener;

  HomeBloc({
    required UserInterface userInterface,
    required GroupsInterface groupsInterface,
  }) : super(const HomeState()) {
    _userInterface = userInterface;
    _groupsInterface = groupsInterface;
    on<HomeEventInitialize>(_initialize);
    on<HomeEventLoggedUserAvatarUrlUpdated>(_loggedUserAvatarUrlUpdated);
  }

  @override
  Future<void> close() {
    _loggedUserAvatarUrlListener?.cancel();
    return super.close();
  }

  Future<void> _initialize(
    HomeEventInitialize event,
    Emitter<HomeState> emit,
  ) async {
    _setLoggedUserAvatarUrlListener();
    try {
      emit(state.copyWith(status: HomeStatusLoading()));
      await _userInterface.loadLoggedUserAvatar();
      await _groupsInterface.loadAllGroups();
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

  void _setLoggedUserAvatarUrlListener() {
    _loggedUserAvatarUrlListener = _userInterface.loggedUserAvatarUrl$.listen(
      (avatarUrl) => add(
        HomeEventLoggedUserAvatarUrlUpdated(newLoggedUserAvatarUrl: avatarUrl),
      ),
    );
  }
}
