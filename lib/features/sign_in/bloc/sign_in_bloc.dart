import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/use_cases/auth/sign_in_use_case.dart';
import '../../../models/bloc_status.dart';

part 'sign_in_event.dart';

part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  late final SignInUseCase _signInUseCase;

  SignInBloc({
    required SignInUseCase signInUseCase,
    BlocStatus status = const BlocStatusInitial(),
    String email = '',
    String password = '',
  }) : super(
          SignInState(
            status: status,
            email: email,
            password: password,
          ),
        ) {
    _signInUseCase = signInUseCase;
    on<SignInEventEmailChanged>(_emailChanged);
    on<SignInEventPasswordChanged>(_passwordChanged);
    on<SignInEventSubmit>(_submit);
    on<SignInEventReset>(_reset);
  }

  void _emailChanged(
    SignInEventEmailChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChanged(
    SignInEventPasswordChanged event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  Future<void> _submit(
    SignInEventSubmit event,
    Emitter<SignInState> emit,
  ) async {
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      try {
        emit(state.copyWith(status: const BlocStatusLoading()));
        await _signInUseCase.execute(
          email: state.email,
          password: state.password,
        );
        emit(state.copyWith());
      } on AuthException catch (error) {
        if (error == AuthException.userNotFound) {
          emit(state.copyWithInfoType(
            SignInInfoType.userNotFound,
          ));
        } else if (error == AuthException.invalidEmail) {
          emit(state.copyWithInfoType(
            SignInInfoType.invalidEmail,
          ));
        } else if (error == AuthException.wrongPassword) {
          emit(state.copyWithInfoType(
            SignInInfoType.wrongPassword,
          ));
        }
      }
    }
  }

  void _reset(
    SignInEventReset event,
    Emitter<SignInState> emit,
  ) {
    emit(state.copyWith(
      email: '',
      password: '',
    ));
  }
}
