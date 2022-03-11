import 'package:fiszkomaniak/models/sign_in_model.dart';
import 'package:fiszkomaniak/models/sign_up_model.dart';
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
    _authSubscriber.subscribe();
  }

  Future<void> signIn(SignInModel data) async {
    await _authInterface.signIn(data);
  }

  Future<void> signUp(SignUpModel data) async {
    await _authInterface.signUp(data);
  }

  void dispose() {
    _authSubscriber.unsubscribe();
  }
}
