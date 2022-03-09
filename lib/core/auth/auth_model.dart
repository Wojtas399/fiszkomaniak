import 'package:fiszkomaniak/interfaces/auth_data_interface.dart';

class AuthModel implements AuthDataInterface {
  final String username;
  final String email;
  final String password;

  AuthModel({
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
