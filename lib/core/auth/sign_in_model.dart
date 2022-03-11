import 'package:fiszkomaniak/interfaces/sign_in_model_interface.dart';

class SignInModel implements SignInModelInterface {
  final String email;
  final String password;

  const SignInModel({required this.email, required this.password});

  @override
  String getEmail() {
    return email;
  }

  @override
  String getPassword() {
    return password;
  }
}
