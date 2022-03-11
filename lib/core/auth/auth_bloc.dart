import 'package:fiszkomaniak/core/auth/sign_in_model.dart';
import 'package:fiszkomaniak/core/auth/sign_up_model.dart';
import 'package:fiszkomaniak/core/auth/auth_subscriber.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';

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

  void initialize() {
    print('bloc initialize');
    _authSubscriber.subscribe();
  }

  Future<void> signIn(SignInModel data) async {
    try {
      await _authInterface.signIn(data);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(SignUpModel data) async {
    try {
      await _authInterface.signUp(data);
    } catch (error) {
      rethrow;
    }
  }

  void dispose() {
    _authSubscriber.unsubscribe();
  }
}
