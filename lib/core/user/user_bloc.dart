import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/core/initialization_status.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'user_event.dart';

part 'user_state.dart';

part 'user_status.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late final UserInterface _userInterface;
  StreamSubscription<User>? _userSubscription;

  UserBloc({
    required UserInterface userInterface,
  }) : super(const UserState()) {
    _userInterface = userInterface;
    on<UserEventInitialize>(_initialize);
    on<UserEventLoggedUserUpdated>(_loggedUserUpdated);
    on<UserEventSaveNewAvatar>(_saveNewAvatar);
    on<UserEventRemoveAvatar>(_removeAvatar);
    on<UserEventChangeUsername>(_changeUsername);
    on<UserEventSaveNewRememberedFlashcards>(_saveNewRememberedFlashcards);
  }

  void _initialize(
    UserEventInitialize event,
    Emitter<UserState> emit,
  ) {
    _userSubscription = _userInterface.getLoggedUserSnapshots().listen((user) {
      add(UserEventLoggedUserUpdated(updatedLoggedUser: user));
    });
  }

  void _loggedUserUpdated(
    UserEventLoggedUserUpdated event,
    Emitter<UserState> emit,
  ) {
    emit(state.copyWith(
      loggedUser: event.updatedLoggedUser,
      initializationStatus: InitializationStatus.ready,
    ));
  }

  Future<void> _saveNewAvatar(
    UserEventSaveNewAvatar event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserStatusLoading()));
      await _userInterface.saveNewAvatar(fullPath: event.imageFullPath);
      emit(state.copyWith(status: UserStatusNewAvatarSaved()));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _removeAvatar(
    UserEventRemoveAvatar event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserStatusLoading()));
      await _userInterface.removeAvatar();
      emit(state.copyWith(status: UserStatusAvatarRemoved()));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _changeUsername(
    UserEventChangeUsername event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserStatusLoading()));
      await _userInterface.saveNewUsername(newUsername: event.newUsername);
      emit(state.copyWith(status: UserStatusUsernameUpdated()));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatusError(message: error.toString()),
      ));
    }
  }

  Future<void> _saveNewRememberedFlashcards(
    UserEventSaveNewRememberedFlashcards event,
    Emitter<UserState> emit,
  ) async {
    try {
      emit(state.copyWith(status: UserStatusLoading()));
      await _userInterface.saveNewRememberedFlashcardsInDays(
        groupId: event.groupId,
        indexesOfFlashcards: event.rememberedFlashcardsIndexes,
      );
      emit(state.copyWith(
        status: UserStatusNewRememberedFlashcardsSaved(),
      ));
    } catch (error) {
      emit(state.copyWith(
        status: UserStatusError(message: error.toString()),
      ));
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }
}
