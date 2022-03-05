import 'package:fiszkomaniak/firebase/services/fire_auth_service.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import '../firebase/repositories/fire_auth_repository.dart';

class FirebaseProvider {
  static AuthInterface provideAuthInterface() {
    return FireAuthRepository(fireAuthService: FireAuthService());
  }
}
