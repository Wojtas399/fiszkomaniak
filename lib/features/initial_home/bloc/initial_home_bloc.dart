import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/is_user_logged_use_case.dart';

part 'initial_home_event.dart';

part 'initial_home_state.dart';

class InitialHomeBloc extends Bloc<InitialHomeEvent, InitialHomeState> {
  late final IsUserLoggedUseCase _isUserLoggedUseCase;
  StreamSubscription<bool>? _userLoginStatusListener;

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
    on<InitialHomeEventUserLoginStatusChanged>(_loginStatusChanged);
  }

  @override
  Future<void> close() {
    _userLoginStatusListener?.cancel();
    return super.close();
  }

  void _initialize(
    InitialHomeEventInitialize event,
    Emitter<InitialHomeState> emit,
  ) {
    _userLoginStatusListener ??= _isUserLoggedUseCase.execute().listen(
          (isUserLogged) => add(
            InitialHomeEventUserLoginStatusChanged(isUserLogged: isUserLogged),
          ),
        );
  }

  void _changeMode(
    InitialHomeEventChangeMode event,
    Emitter<InitialHomeState> emit,
  ) {
    emit(state.copyWith(
      mode: event.mode,
    ));
  }

  void _loginStatusChanged(
    InitialHomeEventUserLoginStatusChanged event,
    Emitter<InitialHomeState> emit,
  ) {
    emit(state.copyWith(
      isUserLogged: event.isUserLogged,
    ));
  }
}
