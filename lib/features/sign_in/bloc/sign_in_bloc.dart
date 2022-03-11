import 'package:bloc/bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/auth/sign_in_model.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthBloc authBloc;

  SignInBloc({required this.authBloc}) : super(const SignInState()) {
    on<SignInEventEmailChanged>(
      (event, emit) => emit(state.copyWith(email: event.email)),
    );
    on<SignInEventPasswordChanged>(
      (event, emit) => emit(state.copyWith(password: event.password)),
    );
    on<SignInEventSubmitted>((event, emit) async {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      try {
        await authBloc.signIn(SignInModel(
          email: event.email,
          password: event.password,
        ));
        emit(state.copyWith(httpStatus: HttpStatusSuccess()));
      } catch (error) {
        emit(state.copyWith(
          httpStatus: HttpStatusFailure(message: error.toString()),
        ));
      }
    });
  }
}
