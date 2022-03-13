import 'package:fiszkomaniak/models/http_status_model.dart';
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

  Future<HttpStatus> signIn(SignInModel data) async {
    try {
      await _authInterface.signIn(data);
      return HttpStatusSuccess();
    } catch (error) {
      return HttpStatusFailure(message: error.toString());
    }
  }

  Future<HttpStatus> signUp(SignUpModel data) async {
    try {
      await _authInterface.signUp(data);
      return HttpStatusSuccess();
    } catch (error) {
      return HttpStatusFailure(message: error.toString());
    }
  }

  Future<HttpStatus> sendPasswordResetEmail(String email) async {
    try {
      await _authInterface.sendPasswordResetEmail(email);
      return HttpStatusSuccess();
    } catch (error) {
      return HttpStatusFailure(message: error.toString());
    }
  }

  void dispose() {
    _authSubscriber.unsubscribe();
  }
}
