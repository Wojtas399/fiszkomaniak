import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:fiszkomaniak/core/validators/user_validator.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({Key? key}) : super(key: key);

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

  _UsernameTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        if (state.username == '') {
          _controller.clear();
        }
        return CustomTextField(
          icon: MdiIcons.account,
          label: 'Nazwa użytkownika',
          isRequired: true,
          placeholder: 'np. Jan Nowak',
          controller: _controller,
          onChanged: (String value) => _onChanged(context, value),
          validator: (String? value) => _validator(state.isCorrectUsername),
        );
      },
    );
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpEventUsernameChanged(username: value));
  }

  String? _validator(bool isCorrect) {
    if (isCorrect) {
      return null;
    }
    return UserValidator.incorrectUsernameMessage;
  }
}

class _EmailTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _EmailTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        if (state.email == '') {
          _controller.clear();
        }
        return CustomTextField(
          icon: MdiIcons.account,
          label: 'Adres email',
          isRequired: true,
          placeholder: 'np. jan.nowak@example.com',
          controller: _controller,
          onChanged: (String value) => _onChanged(context, value),
          validator: (String? value) => _validator(state.isCorrectEmail),
        );
      },
    );
  }

  void _onChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpEventEmailChanged(email: value));
  }

  String? _validator(bool isCorrect) {
    if (isCorrect) {
      return null;
    }
    return UserValidator.incorrectEmailMessage;
  }
}

class _PasswordTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _PasswordTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        if (state.password == '') {
          _controller.clear();
        }
        return PasswordTextField(
          label: 'Hasło',
          isRequired: true,
          controller: _controller,
          onChanged: (String value) => _onChanged(context, value),
          validator: (String? value) => _validator(state.isCorrectPassword),
        );
      },
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
    return UserValidator.incorrectPasswordMessage;
  }
}

class _PasswordConfirmationTextField extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _PasswordConfirmationTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (BuildContext context, SignUpState state) {
        if (state.passwordConfirmation == '') {
          _controller.clear();
        }
        return PasswordTextField(
          label: 'Powtórz hasło',
          isRequired: true,
          controller: _controller,
          onChanged: (String value) => _onChanged(context, value),
          validator: (String? value) => _validator(
            state.isCorrectPasswordConfirmation,
          ),
        );
      },
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
    return 'Hasła i nie są jednakowe';
  }
}
