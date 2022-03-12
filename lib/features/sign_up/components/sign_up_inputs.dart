import 'package:fiszkomaniak/components/textfield.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SignUpInputs extends StatelessWidget {
  const SignUpInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              icon: MdiIcons.account,
              label: 'Nazwa użytkownika',
              placeholder: 'np. Jan Nowak',
              onChanged: (String username) => _onUsernameChanged(
                context,
                username,
              ),
              validator: (String? value) => _validator(
                value,
                state.isCorrectUsername,
                state.incorrectUsernameMessage,
              ),
            ),
            const _FreeSpace(),
            CustomTextField(
              icon: MdiIcons.email,
              label: 'Adres e-mail',
              placeholder: 'np. jan.nowak@example.com',
              onChanged: (String email) => _onEmailChanged(context, email),
              validator: (String? value) => _validator(
                value,
                state.isCorrectEmail,
                state.incorrectEmailMessage,
              ),
            ),
            const _FreeSpace(),
            PasswordTextField(
              label: 'Hasło',
              onChanged: (String password) => _onPasswordChanged(
                context,
                password,
              ),
              validator: (String? value) => _validator(
                value,
                state.isCorrectPassword,
                state.incorrectPasswordMessage,
              ),
            ),
            const _FreeSpace(),
            PasswordTextField(
              label: 'Powtórz hasło',
              onChanged: (String passwordConfirmation) =>
                  _onPasswordConfirmationChanged(
                context,
                passwordConfirmation,
              ),
              validator: (String? value) => _validator(
                value,
                state.isCorrectPasswordConfirmation,
                state.incorrectPasswordConfirmationMessage,
              ),
            ),
          ],
        );
      },
    );
  }

  void _onUsernameChanged(BuildContext context, String username) {
    context
        .read<SignUpBloc>()
        .add(SignUpEventUsernameChanged(username: username));
  }

  void _onEmailChanged(BuildContext context, String email) {
    context.read<SignUpBloc>().add(SignUpEventEmailChanged(email: email));
  }

  void _onPasswordChanged(BuildContext context, String password) {
    context
        .read<SignUpBloc>()
        .add(SignUpEventPasswordChanged(password: password));
  }

  void _onPasswordConfirmationChanged(
    BuildContext context,
    String passwordConfirmation,
  ) {
    context.read<SignUpBloc>().add(SignUpEventPasswordConfirmationChanged(
          passwordConfirmation: passwordConfirmation,
        ));
  }

  String? _validator(
    String? value,
    bool isCorrect,
    String incorrectValueMessage,
  ) {
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
