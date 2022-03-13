import 'package:bloc/bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
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
    on<SignInEventSubmit>((event, emit) async {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      HttpStatus result = await authBloc.signIn(SignInModel(
        email: event.email,
        password: event.password,
      ));
      emit(state.copyWith(httpStatus: result));
    });
    on<SignInEventReset>((event, emit) => emit(const SignInState()));
  }
}
