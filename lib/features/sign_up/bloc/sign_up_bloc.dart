import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_model.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthBloc authBloc;

  SignUpBloc({required this.authBloc}) : super(SignUpState()) {
    on<SignUpEvent>((event, emit) {
      if (event is SignUpEventUsernameChanged) {
        emit(state.copyWith(username: event.username));
      } else if (event is SignUpEventEmailChanged) {
        emit(state.copyWith(email: event.email));
      } else if (event is SignUpEventPasswordChanged) {
        emit(state.copyWith(password: event.password));
      } else if (event is SignUpEventPasswordConfirmationChanged) {
        emit(state.copyWith(passwordConfirmation: event.passwordConfirmation));
      } else if (event is SignUpEventSubmitted) {
        authBloc.signUp(AuthModel(
          username: event.username,
          email: event.email,
          password: event.password,
        ));
      }
    });
  }
}
