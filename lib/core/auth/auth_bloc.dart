import 'package:fiszkomaniak/core/auth/auth_model.dart';
import 'package:fiszkomaniak/core/auth/auth_subscriber.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'auth_model.dart';

class AuthBloc {
  late final AuthInterface _authInterface;
  late final AuthSubscriber _authSubscriber;

  AuthBloc({
    required AuthInterface authInterface,
    required AuthSubscriber authSubscriber,
  }) {
    _authInterface = authInterface;
    _authSubscriber = authSubscriber;
  }

  initialize() {
    print('bloc initialize');
    _authSubscriber.subscribe();
  }

  signUp(AuthModel data) async {
    try {
      await _authInterface.signUp(data);
    } catch (error) {
      rethrow;
    }
  }

  dispose() {
    _authSubscriber.unsubscribe();
  }
}
