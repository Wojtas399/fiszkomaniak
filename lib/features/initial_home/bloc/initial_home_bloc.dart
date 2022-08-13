import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/is_user_logged_use_case.dart';

part 'initial_home_event.dart';

part 'initial_home_state.dart';

class InitialHomeBloc extends Bloc<InitialHomeEvent, InitialHomeState> {
  late final IsUserLoggedUseCase _isUserLoggedUseCase;

  InitialHomeBloc({
    required IsUserLoggedUseCase isUserLoggedUseCase,
    InitialHomeMode mode = InitialHomeMode.login,
    bool isUserLogged = false,
  }) : super(
          InitialHomeState(mode: mode, isUserLogged: isUserLogged),
        ) {
    _isUserLoggedUseCase = isUserLoggedUseCase;
    on<InitialHomeEventInitialize>(_initialize);
    on<InitialHomeEventChangeMode>(_changeMode);
  }

  Future<void> _initialize(
    InitialHomeEventInitialize event,
    Emitter<InitialHomeState> emit,
  ) async {
    final bool isUserLogged = await _isUserLoggedUseCase.execute().first;
    emit(state.copyWith(
      isUserLogged: isUserLogged,
    ));
  }

  void _changeMode(
    InitialHomeEventChangeMode event,
    Emitter<InitialHomeState> emit,
  ) {
    emit(state.copyWith(
      mode: event.mode,
    ));
  }
}
