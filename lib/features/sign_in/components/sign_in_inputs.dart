import 'package:fiszkomaniak/components/textfield.dart';
import 'package:fiszkomaniak/components/textfields/password_textfield.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
              controller: state.emailController,
              onChanged: (_) => _refreshState(context),
            ),
            const SizedBox(height: 8),
            PasswordTextField(
              label: 'Hasło',
              controller: state.passwordController,
              onChanged: (_) => _refreshState(context),
            ),
          ],
        );
      },
    );
  }

  void _refreshState(BuildContext context) {
    context.read<SignInBloc>().add(SignInEventRefresh());
  }
}
