import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/textfields/custom_textfield.dart';
import '../../../components/textfields/password_textfield.dart';
import '../bloc/sign_in_bloc.dart';

class SignInInputs extends StatelessWidget {
  const SignInInputs({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Email(),
        const SizedBox(height: 8),
        _Password(),
      ],
    );
  }
}

class _Email extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String email = context.select((SignInBloc bloc) => bloc.state.email);
    if (email == '') {
      _emailController.clear();
    }
    return CustomTextField(
      label: 'Adres e-mail',
      icon: MdiIcons.email,
      controller: _emailController,
      onChanged: (String value) => _onEmailChanged(context, value),
    );
  }

  void _onEmailChanged(BuildContext context, String value) {
    context.read<SignInBloc>().add(SignInEventEmailChanged(email: value));
  }
}

class _Password extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final String password = context.select(
      (SignInBloc bloc) => bloc.state.password,
    );
    if (password == '') {
      _passwordController.clear();
    }
    return PasswordTextField(
      label: 'Hasło',
      controller: _passwordController,
      onChanged: (String value) => _onPasswordChanged(context, value),
    );
  }

  void _onPasswordChanged(BuildContext context, String value) {
    context.read<SignInBloc>().add(SignInEventPasswordChanged(password: value));
  }
}
