import 'package:equatable/equatable.dart';

class SignUpModel extends Equatable {
  final String username;
  final String email;
  final String password;

  const SignUpModel({
    required this.username,
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [
        username,
        email,
        password,
      ];
}
