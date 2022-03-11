import 'package:fiszkomaniak/components/textfield.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../bloc/sign_in_event.dart';
import '../bloc/sign_in_state.dart';

class SignInInputs extends StatelessWidget {
  const SignInInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomTextField(
              label: 'Adres e-mail',
              icon: MdiIcons.email,
              onChanged: (String email) => _onEmailChanged(context, email),
            ),
            const SizedBox(height: 8),
            CustomTextField(
              label: 'Hasło',
              icon: MdiIcons.lock,
              isPassword: true,
              onChanged: (String password) => _onPasswordChanged(
                context,
                password,
              ),
            ),
          ],
        );
      },
    );
  }

  _onEmailChanged(BuildContext context, String email) {
    context.read<SignInBloc>().add(SignInEventEmailChanged(email: email));
  }

  _onPasswordChanged(BuildContext context, String password) {
    context
        .read<SignInBloc>()
        .add(SignInEventPasswordChanged(password: password));
  }
}
