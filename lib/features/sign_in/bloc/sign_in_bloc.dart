import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  // final AuthBloc authBloc;

  SignInBloc() : super(const SignInState()) {
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

  void _submit(
    SignInEventSubmit event,
    Emitter<SignInState> emit,
  ) {
    if (state.email.isNotEmpty && state.password.isNotEmpty) {
      // authBloc.add(AuthEventSignIn(
      //   email: state.email,
      //   password: state.password,
      // ));
    }
  }

  void _reset(
    SignInEventReset event,
    Emitter<SignInState> emit,
  ) {
    emit(const SignInState());
  }
}
