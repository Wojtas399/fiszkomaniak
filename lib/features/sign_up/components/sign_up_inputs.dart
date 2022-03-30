import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpInputs extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  SignUpInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        if (state.username == '') {
          _usernameController.clear();
        }
        if (state.email == '') {
          _emailController.clear();
        }
        if (state.password == '') {
          _passwordController.clear();
        }
        if (state.passwordConfirmation == '') {
          _passwordConfirmationController.clear();
        }
        return Column(
          children: [
            CustomTextField(
              icon: MdiIcons.account,
              label: 'Nazwa użytkownika',
              placeholder: 'np. Jan Nowak',
              controller: _usernameController,
              onChanged: (String value) => _onUsernameChanged(context, value),
              validator: (String? value) => _validator(
                state.hasUsernameBeenEdited ? value : null,
                state.isCorrectUsername,
                state.incorrectUsernameMessage,
              ),
            ),
            const _FreeSpace(),
            CustomTextField(
              icon: MdiIcons.email,
              label: 'Adres e-mail',
              placeholder: 'np. jan.nowak@example.com',
              controller: _emailController,
              onChanged: (String value) => _onEmailChanged(context, value),
              validator: (String? value) => _validator(
                state.hasEmailBeenEdited ? value : null,
                state.isCorrectEmail,
                state.incorrectEmailMessage,
              ),
            ),
            const _FreeSpace(),
            PasswordTextField(
              label: 'Hasło',
              controller: _passwordController,
              onChanged: (String value) => _onPasswordChanged(context, value),
              validator: (String? value) => _validator(
                state.hasPasswordBeenEdited ? value : null,
                state.isCorrectPassword,
                state.incorrectPasswordMessage,
              ),
            ),
            const _FreeSpace(),
            PasswordTextField(
              label: 'Powtórz hasło',
              controller: _passwordConfirmationController,
              onChanged: (String value) =>
                  _onPasswordConfirmationChanged(context, value),
              validator: (String? value) => _validator(
                state.hasPasswordConfirmationBeenEdited ? value : null,
                state.isCorrectPasswordConfirmation,
                state.incorrectPasswordConfirmationMessage,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onUsernameChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpEventUsernameChanged(username: value));
  }

  void _onEmailChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpEventEmailChanged(email: value));
  }

  void _onPasswordChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(SignUpEventPasswordChanged(password: value));
  }

  void _onPasswordConfirmationChanged(BuildContext context, String value) {
    context.read<SignUpBloc>().add(
          SignUpEventPasswordConfirmationChanged(passwordConfirmation: value),
        );
  }

  String? _validator(
    String? value,
    bool isCorrect,
    String incorrectValueMessage,
  ) {
    if (value == null) {
      return null;
    }
    if (value == '') {
      return 'To pole jest wymagane';
    } else if (!isCorrect) {
      return incorrectValueMessage;
    }
    return null;
  }
}

class _FreeSpace extends StatelessWidget {
  const _FreeSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}
