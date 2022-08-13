import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/auth/sign_up_use_case.dart';
import '../../../exceptions/auth_exceptions.dart';
import '../../../models/bloc_status.dart';
import '../../../validators/email_validator.dart';
import '../../../validators/password_validator.dart';
import '../../../validators/username_validator.dart';

part 'sign_up_event.dart';

part 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  late final SignUpUseCase _signUpUseCase;

  SignUpBloc({
    required SignUpUseCase signUpUseCase,
    required UsernameValidator usernameValidator,
    required EmailValidator emailValidator,
    required PasswordValidator passwordValidator,
    BlocStatus status = const BlocStatusInitial(),
    String username = '',
    String email = '',
    String password = '',
    String passwordConfirmation = '',
  }) : super(
          SignUpState(
            usernameValidator: usernameValidator,
            emailValidator: emailValidator,
            passwordValidator: passwordValidator,
            status: status,
            username: username,
            email: email,
            password: password,
            passwordConfirmation: passwordConfirmation,
          ),
        ) {
    _signUpUseCase = signUpUseCase;
    on<SignUpEventUsernameChanged>(_usernameChanged);
    on<SignUpEventEmailChanged>(_emailChanged);
    on<SignUpEventPasswordChanged>(_passwordChanged);
    on<SignUpEventPasswordConfirmationChanged>(_passwordConfirmationChanged);
    on<SignUpEventSubmit>(_submit);
    on<SignUpEventReset>(_reset);
  }

  void _usernameChanged(
    SignUpEventUsernameChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(username: event.username));
  }

  void _emailChanged(
    SignUpEventEmailChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(email: event.email));
  }

  void _passwordChanged(
    SignUpEventPasswordChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(password: event.password));
  }

  void _passwordConfirmationChanged(
    SignUpEventPasswordConfirmationChanged event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(passwordConfirmation: event.passwordConfirmation));
  }

  Future<void> _submit(
    SignUpEventSubmit event,
    Emitter<SignUpState> emit,
  ) async {
    if (state.isUsernameValid &&
        state.isEmailValid &&
        state.isPasswordValid &&
        state.isPasswordConfirmationValid) {
      try {
        emit(state.copyWith(
          status: const BlocStatusLoading(),
        ));
        await _signUpUseCase.execute(
          username: state.username,
          email: state.email,
          password: state.password,
        );
        emit(state.copyWithInfo(
          SignUpInfo.userHasBeenSignedUp,
        ));
      } on AuthException catch (exception) {
        if (exception == AuthException.emailAlreadyInUse) {
          emit(state.copyWithError(
            SignUpError.emailAlreadyInUse,
          ));
        }
      }
    }
  }

  void _reset(
    SignUpEventReset event,
    Emitter<SignUpState> emit,
  ) {
    emit(state.copyWith(
      username: '',
      email: '',
      password: '',
      passwordConfirmation: '',
    ));
  }
}
