import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_exception_model.dart';

part 'auth_state.dart';

part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  late final AuthInterface _authInterface;
  late final SettingsInterface _settingsInterface;
  StreamSubscription<bool>? _subscription;

  AuthBloc({
    required AuthInterface authInterface,
    required SettingsInterface settingsInterface,
  }) : super(const AuthStateInitial()) {
    _authInterface = authInterface;
    _settingsInterface = settingsInterface;
    on<AuthEventInitialize>(_initialize);
    on<AuthEventLoggedUserStatusChanged>(_loggedUserStatusChanged);
    on<AuthEventSignIn>(_signIn);
    on<AuthEventSignUp>(_signUp);
    on<AuthEventSendPasswordResetEmail>(_sendPasswordResetEmail);
    on<AuthEventChangePassword>(_changePassword);
    on<AuthEventRemoveLoggedUser>(_removeLoggedUser);
    on<AuthEventSignOut>(_signOut);
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void _initialize(
    AuthEventInitialize event,
    Emitter<AuthState> emit,
  ) {
    _subscription = _authInterface.isLoggedUser().listen(
      (bool isLoggedUser) {
        add(AuthEventLoggedUserStatusChanged(isLoggedUser: isLoggedUser));
      },
    );
  }

  void _loggedUserStatusChanged(
    AuthEventLoggedUserStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    if (event.isLoggedUser) {
      emit(AuthStateSignedIn());
    } else {
      emit(AuthStateSignedOut());
    }
  }

  Future<void> _signIn(
    AuthEventSignIn event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStateLoading());
      await _authInterface.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AuthStateSignedIn());
    } on AuthException catch (error) {
      _onAuthException(error, emit);
    } catch (error) {
      emit(AuthStateError(message: error.toString()));
    }
  }

  Future<void> _signUp(
    AuthEventSignUp event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStateLoading());
      await _authInterface.signUp(
        username: event.username,
        email: event.email,
        password: event.password,
      );
      await _settingsInterface.setDefaultUserSettings();
      emit(AuthStateSignedIn());
    } on AuthException catch (error) {
      _onAuthException(error, emit);
    } catch (error) {
      emit(AuthStateError(message: error.toString()));
    }
  }

  Future<void> _sendPasswordResetEmail(
    AuthEventSendPasswordResetEmail event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStateLoading());
      await _authInterface.sendPasswordResetEmail(event.email);
      emit(AuthStatePasswordResetEmailSent());
    } on AuthException catch (error) {
      _onAuthException(error, emit);
    } catch (error) {
      emit(AuthStateError(message: error.toString()));
    }
  }

  Future<void> _changePassword(
    AuthEventChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStateLoading());
      await _authInterface.changePassword(
        currentPassword: event.currentPassword,
        newPassword: event.newPassword,
      );
      emit(AuthStatePasswordChanged());
    } on AuthException catch (error) {
      _onAuthException(error, emit);
    } catch (error) {
      emit(AuthStateError(message: error.toString()));
    }
  }

  Future<void> _removeLoggedUser(
    AuthEventRemoveLoggedUser event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStateLoading());
      await _authInterface.removeLoggedUser(password: event.password);
    } on AuthException catch (error) {
      _onAuthException(error, emit);
    } catch (error) {
      emit(AuthStateError(message: error.toString()));
    }
  }

  Future<void> _signOut(
    AuthEventSignOut event,
    Emitter<AuthState> emit,
  ) async {
    try {
      emit(AuthStateLoading());
      await _authInterface.signOut();
    } catch (error) {
      emit(AuthStateError(message: error.toString()));
    }
  }

  void _onAuthException(AuthException error, Emitter<AuthState> emit) {
    switch (error.code) {
      case AuthErrorCode.userNotFound:
        emit(AuthStateUserNotFound());
        break;
      case AuthErrorCode.wrongPassword:
        emit(AuthStateWrongPassword());
        break;
      case AuthErrorCode.invalidEmail:
        emit(AuthStateInvalidEmail());
        break;
      case AuthErrorCode.emailAlreadyInUse:
        emit(AuthStateEmailAlreadyInUse());
        break;
    }
  }
}
