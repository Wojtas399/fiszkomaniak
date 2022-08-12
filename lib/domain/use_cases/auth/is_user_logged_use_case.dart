import '../../../interfaces/auth_interface.dart';

class IsUserLoggedUseCase {
  late final AuthInterface _authInterface;

  IsUserLoggedUseCase({required AuthInterface authInterface}) {
    _authInterface = authInterface;
  }

  Stream<bool> execute() {
    return _authInterface.isUserLogged$;
  }
}
