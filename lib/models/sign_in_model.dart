import 'package:equatable/equatable.dart';

class SignInModel extends Equatable {
  final String email;
  final String password;

  const SignInModel({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}
