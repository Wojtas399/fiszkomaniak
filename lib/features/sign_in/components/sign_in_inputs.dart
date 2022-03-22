import 'package:fiszkomaniak/components/textfields/textfield.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../bloc/sign_in_state.dart';

class SignInInputs extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignInInputs({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
        if (state.email == '') {
          _emailController.clear();
        }
        if (state.password == '') {
          _passwordController.clear();
        }
        return Column(
          children: [
            CustomTextField(
              label: 'Adres e-mail',
              icon: MdiIcons.email,
              controller: _emailController,
              onChanged: (String value) => _onEmailChanged(context, value),
            ),
            const SizedBox(height: 8),
            PasswordTextField(
              label: 'Hasło',
              controller: _passwordController,
              onChanged: (String value) => _onPasswordChanged(context, value),
            ),
          ],
        );
      },
    );
  }

  void _onEmailChanged(BuildContext context, String value) {
    context.read<SignInBloc>().add(SignInEventEmailChanged(email: value));
  }

  void _onPasswordChanged(BuildContext context, String value) {
    context.read<SignInBloc>().add(SignInEventPasswordChanged(password: value));
  }
}
