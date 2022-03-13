import 'package:equatable/equatable.dart';

class SignUpModel extends Equatable {
  late final String _username;
  late final String _email;
  late final String _password;

  SignUpModel({
    required String username,
    required String email,
    required String password,
  }) {
    _username = username;
    _email = email;
    _password = password;
  }

  String get username => _username;

  String get email => _email;

  String get password => _password;

  @override
  List<Object> get props => [
        _username,
        _email,
        _password,
      ];
}
