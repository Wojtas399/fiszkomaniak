class SignUpModel {
  late String _username;
  late String _email;
  late String _password;

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
}
