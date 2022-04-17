import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/models/http_status_model.dart';
import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter/cupertino.dart';

class AuthBloc {
  late final AuthInterface _authInterface;
  late final SettingsInterface _settingsInterface;
  StreamSubscription<User?>? _subscription;

  AuthBloc({
    required AuthInterface authInterface,
    required SettingsInterface settingsInterface,
  }) {
    _authInterface = authInterface;
    _settingsInterface = settingsInterface;
  }

  void initialize({
    required VoidCallback onUserLogged,
  }) {
    _subscription = _authInterface.getUserChangesStream().listen((user) {
      if (user != null) {
        onUserLogged();
      }
    });
  }

  Future<HttpStatus> signIn(SignInModel data) async {
    try {
      await _authInterface.signIn(data);
      return const HttpStatusSuccess();
    } catch (error) {
      return HttpStatusFailure(message: error.toString());
    }
  }

  Future<HttpStatus> signUp(SignUpModel data) async {
    try {
      await _authInterface.signUp(data);
      await _settingsInterface.setDefaultSettings();
      return const HttpStatusSuccess();
    } catch (error) {
      return HttpStatusFailure(message: error.toString());
    }
  }

  Future<HttpStatus> sendPasswordResetEmail(String email) async {
    try {
      await _authInterface.sendPasswordResetEmail(email);
      return const HttpStatusSuccess();
    } catch (error) {
      return HttpStatusFailure(message: error.toString());
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
