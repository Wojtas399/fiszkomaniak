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
              controller: state.usernameController,
              onChanged: (_) => _onUsernameChanged(context, state),
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
              controller: state.emailController,
              onChanged: (_) => _onEmailChanged(context, state),
              validator: (String? value) => _validator(
                state.hasEmailBeenEdited ? value : null,
                state.isCorrectEmail,
                state.incorrectEmailMessage,
              ),
            ),
            const _FreeSpace(),
            PasswordTextField(
              label: 'Hasło',
              controller: state.passwordController,
              onChanged: (_) => _onPasswordChanged(context, state),
              validator: (String? value) => _validator(
                state.hasPasswordBeenEdited ? value : null,
                state.isCorrectPassword,
                state.incorrectPasswordMessage,
              ),
            ),
            const _FreeSpace(),
            PasswordTextField(
              label: 'Powtórz hasło',
              controller: state.passwordConfirmationController,
              onChanged: (_) => _onPasswordConfirmationChanged(context, state),
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

  void _onUsernameChanged(BuildContext context, SignUpState state) {
    if (!state.hasUsernameBeenEdited) {
      context.read<SignUpBloc>().add(SignUpEventStartUsernameEditing());
    } else {
      _refreshState(context);
    }
  }

  void _onEmailChanged(BuildContext context, SignUpState state) {
    if (!state.hasEmailBeenEdited) {
      context.read<SignUpBloc>().add(SignUpEventStartEmailEditing());
    } else {
      _refreshState(context);
    }
  }

  void _onPasswordChanged(BuildContext context, SignUpState state) {
    if (!state.hasPasswordBeenEdited) {
      context.read<SignUpBloc>().add(SignUpEventStartPasswordEditing());
    } else {
      _refreshState(context);
    }
  }

  void _onPasswordConfirmationChanged(
    BuildContext context,
    SignUpState state,
  ) {
    if (!state.hasPasswordConfirmationBeenEdited) {
      context
          .read<SignUpBloc>()
          .add(SignUpEventStartPasswordConfirmationEditing());
    } else {
      _refreshState(context);
    }
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

  void _refreshState(BuildContext context) {
    context.read<SignUpBloc>().add(SignUpEventRefresh());
  }
}

class _FreeSpace extends StatelessWidget {
  const _FreeSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 8);
  }
}
