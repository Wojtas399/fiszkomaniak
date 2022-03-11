import 'package:fiszkomaniak/interfaces/sign_up_model_interface.dart';

class SignUpModel implements SignUpModelInterface {
  final String username;
  final String email;
  final String password;

  SignUpModel({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  String getUsername() {
    return username;
  }

  @override
  String getEmail() {
    return email;
  }

  @override
  String getPassword() {
    return password;
  }
}
