import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';

class AuthSubscriber {
  late final AuthInterface _authInterface;
  StreamSubscription<User?>? _subscription;

  AuthSubscriber({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  subscribe() {
    _subscription = _authInterface.getUserChangesStream().listen((user) {
      if (user != null) {
        Navigation.navigateToHome();
      }
    });
  }

  unsubscribe() {
    _subscription?.cancel();
  }
}
