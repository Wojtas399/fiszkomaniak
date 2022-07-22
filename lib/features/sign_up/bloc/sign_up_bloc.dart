import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  // final AuthBloc authBloc;

  SignUpBloc() : super(const SignUpState()) {
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

  void _submit(
    SignUpEventSubmit event,
    Emitter<SignUpState> emit,
  ) {
    if (state.isCorrectUsername &&
        state.isCorrectEmail &&
        state.isCorrectPassword &&
        state.isCorrectPasswordConfirmation) {
      // authBloc.add(AuthEventSignUp(
      //   username: state.username,
      //   email: state.email,
      //   password: state.password,
      // ));
    }
  }

  void _reset(
    SignUpEventReset event,
    Emitter<SignUpState> emit,
  ) {
    emit(const SignUpState());
  }
}
