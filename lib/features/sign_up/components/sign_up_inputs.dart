import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/textfields/custom_textfield.dart';
import '../../../components/textfields/password_textfield.dart';
import '../../../validators/email_validator.dart';
import '../../../validators/password_validator.dart';
import '../../../validators/username_validator.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({super.key});

  @override
  Widget build(BuildContext context) {
    const Widget gap = SizedBox(height: 8.0);
    return Column(
      children: [
        _UsernameTextField(),
        gap,
        _EmailTextField(),
        gap,
        _PasswordTextField(),
        gap,
        _PasswordConfirmationTextField(),
      ],
    );
  }
}

class _UsernameTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String username = context.select(
      (SignUpBloc bloc) => bloc.state.username,
    );
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isUsernameValid,
    );
    if (username == '') {
      _controller.clear();
    }
    return CustomTextField(
      icon: MdiIcons.account,
      label: 'Nazwa użytkownika',
      isRequired: true,
      placeholder: 'np. Jan Nowak',
      controller: _controller,
      onChanged: (String value) => _onChanged(context, value),
      validator: (String? value) => _validator(isValid),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(
          SignUpEventUsernameChanged(username: value),
        );
  }

  String? _validator(bool isCorrect) {
    if (isCorrect) {
      return null;
    }
    return UsernameValidator.message;
  }
}

class _EmailTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String email = context.select(
      (SignUpBloc bloc) => bloc.state.email,
    );
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isEmailValid,
    );
    if (email == '') {
      _controller.clear();
    }
    return CustomTextField(
      icon: MdiIcons.account,
      label: 'Adres email',
      isRequired: true,
      placeholder: 'np. jan.nowak@example.com',
      controller: _controller,
      onChanged: (String value) => _onChanged(context, value),
      validator: (String? value) => _validator(isValid),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(
          SignUpEventEmailChanged(email: value),
        );
  }

  String? _validator(bool isCorrect) {
    if (isCorrect) {
      return null;
    }
    return EmailValidator.message;
  }
}

class _PasswordTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String password = context.select(
      (SignUpBloc bloc) => bloc.state.password,
    );
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordValid,
    );
    if (password == '') {
      _controller.clear();
    }
    return PasswordTextField(
      label: 'Hasło',
      isRequired: true,
      controller: _controller,
      onChanged: (String value) => _onChanged(context, value),
      validator: (String? value) => _validator(isValid),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordChanged(password: value),
        );
  }

  String? _validator(bool isCorrect) {
    if (isCorrect) {
      return null;
    }
    return PasswordValidator.message;
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String passwordConfirmation = context.select(
      (SignUpBloc bloc) => bloc.state.passwordConfirmation,
    );
    final bool isValid = context.select(
      (SignUpBloc bloc) => bloc.state.isPasswordConfirmationValid,
    );
    if (passwordConfirmation == '') {
      _controller.clear();
    }
    return PasswordTextField(
      label: 'Powtórz hasło',
      isRequired: true,
      controller: _controller,
      onChanged: (String value) => _onChanged(context, value),
      validator: (String? value) => _validator(isValid),
    );
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordConfirmationChanged(passwordConfirmation: value),
        );
  }

  String? _validator(bool isCorrect) {
    if (isCorrect) {
      return null;
    }
    return 'Hasła nie są jednakowe';
  }
}
