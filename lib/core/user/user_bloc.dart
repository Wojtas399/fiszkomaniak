import 'dart:async';
import 'package:fiszkomaniak/core/user/user_event.dart';
import 'package:fiszkomaniak/core/user/user_state.dart';
import 'package:fiszkomaniak/core/user/user_status.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/models/user_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  late final UserInterface _userInterface;
  StreamSubscription<User>? _userSubscription;

  UserBloc({
    required UserInterface userInterface,
  }) : super(const UserState()) {
    _userInterface = userInterface;
    on<UserEventInitialize>(_initialize);
    on<UserEventLoggedUserUpdated>(_loggedUserUpdated);
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
    emit(state.copyWith(loggedUser: event.updatedLoggedUser));
  }

  void _saveNewRememberedFlashcards(
    UserEventSaveNewRememberedFlashcards event,
    Emitter<UserState> emit,
  ) {
    try {
      emit(state.copyWith(status: UserStatusLoading()));
      _userInterface.saveNewRememberedFlashcardsInDays(
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
