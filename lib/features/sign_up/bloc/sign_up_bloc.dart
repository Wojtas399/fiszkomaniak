import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthBloc authBloc;

  SignUpBloc({required this.authBloc}) : super(const SignUpState()) {
    on<SignUpEventUsernameChanged>(
      (event, emit) => emit(state.copyWith(username: event.username)),
    );
    on<SignUpEventEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    on<SignUpEventPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<SignUpEventPasswordConfirmationChanged>(
      (event, emit) => emit(state.copyWith(
        passwordConfirmation: event.passwordConfirmation,
      )),
    );
    on<SignUpEventSubmit>((event, emit) async {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      HttpStatus result = await authBloc.signUp(
        SignUpModel(
          username: event.username,
          email: event.email,
          password: event.password,
        ),
      );
      emit(state.copyWith(httpStatus: result));
    });
    on<SignUpEventReset>((event, emit) => emit(const SignUpState()));
  }
}
