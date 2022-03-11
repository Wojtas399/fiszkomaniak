class SignInModel {
  late String _email;
  late String _password;

  SignInModel({required String email, required String password}) {
    _email = email;
    _password = password;
  }

  String get email => _email;

  String get password => _password;
}
