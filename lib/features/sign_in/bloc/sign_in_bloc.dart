import 'package:bloc/bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final AuthBloc authBloc;

  SignInBloc({required this.authBloc}) : super(SignInState()) {
    on<SignInEventRefresh>(
      (event, emit) => emit(state.copyWithHttpStatus(null)),
    );
    on<SignInEventSubmitted>((event, emit) async {
      emit(state.copyWithHttpStatus(HttpStatusSubmitting()));
      try {
        await authBloc.signIn(SignInModel(
          email: event.email,
          password: event.password,
        ));
        emit(state.copyWithHttpStatus(HttpStatusSuccess()));
      } catch (error) {
        emit(state.copyWithHttpStatus(
          HttpStatusFailure(message: error.toString()),
        ));
      }
    });
    on<SignInEventResetValues>((event, emit) => emit(SignInState()));
  }
}
