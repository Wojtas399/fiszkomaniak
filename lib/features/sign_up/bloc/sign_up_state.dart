part of 'sign_up_bloc.dart';

class SignUpState extends Equatable {
  late final UsernameValidator _usernameValidator;
  late final EmailValidator _emailValidator;
  late final PasswordValidator _passwordValidator;
  final BlocStatus status;
  final String username;
  final String email;
  final String password;
  final String passwordConfirmation;

  SignUpState({
    required UsernameValidator usernameValidator,
    required EmailValidator emailValidator,
    required PasswordValidator passwordValidator,
    required this.status,
    required this.username,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
  }) {
    _usernameValidator = usernameValidator;
    _emailValidator = emailValidator;
    _passwordValidator = passwordValidator;
  }

  @override
  List<Object> get props => [
        status,
        username,
        email,
        password,
        passwordConfirmation,
      ];

  bool get isUsernameValid => _usernameValidator.isValid(username);

  bool get isEmailValid => _emailValidator.isValid(email);

  bool get isPasswordValid => _passwordValidator.isValid(password);

  bool get isPasswordConfirmationValid => password == passwordConfirmation;

  bool get isButtonDisabled =>
      !isUsernameValid ||
      !isEmailValid ||
      !isPasswordValid ||
      !isPasswordConfirmationValid;

  SignUpState copyWith({
    BlocStatus? status,
    String? username,
    String? email,
    String? password,
    String? passwordConfirmation,
  }) {
    return SignUpState(
      usernameValidator: _usernameValidator,
      emailValidator: _emailValidator,
      passwordValidator: _passwordValidator,
      status: status ?? const BlocStatusInProgress(),
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      passwordConfirmation: passwordConfirmation ?? this.passwordConfirmation,
    );
  }
}

enum SignUpInfoType {
  userHasBeenSignedUp,
}

enum SignUpErrorType {
  emailAlreadyInUse,
}
