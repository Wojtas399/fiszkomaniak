import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final AuthBloc authBloc;

  SignUpBloc({required this.authBloc}) : super(SignUpState()) {
    on<SignUpEventStartUsernameEditing>(
      (event, emit) => emit(state.copyWith(hasUsernameBeenEdited: true)),
    );
    on<SignUpEventStartEmailEditing>(
      (event, emit) => emit(state.copyWith(hasEmailBeenEdited: true)),
    );
    on<SignUpEventStartPasswordEditing>(
      (event, emit) => emit(state.copyWith(hasPasswordBeenEdited: true)),
    );
    on<SignUpEventStartPasswordConfirmationEditing>(
      (event, emit) => emit(
        state.copyWith(hasPasswordConfirmationBeenEdited: true),
      ),
    );
    on<SignUpEventRefresh>((event, emit) => emit(state.copyWith()));
    on<SignUpEventSubmitted>((event, emit) async {
      emit(state.copyWith(httpStatus: HttpStatusSubmitting()));
      try {
        await authBloc.signUp(
          SignUpModel(
            username: event.username,
            email: event.email,
            password: event.password,
          ),
        );
        emit(state.copyWith(httpStatus: HttpStatusSuccess()));
      } catch (error) {
        emit(state.copyWith(
          httpStatus: HttpStatusFailure(message: error.toString()),
        ));
      }
    });
    on<SignUpEventResetValues>((event, emit) => emit(SignUpState()));
  }
}
