import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/features/sign_in/components/sign_in_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'components/sign_in_alternative_options.dart';
import 'components/sign_in_inputs.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignInBloc(authBloc: context.read<AuthBloc>()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Header(),
          SizedBox(height: 24),
          SignInInputs(),
          SizedBox(height: 8),
          SignInSubmitButton(),
          SizedBox(height: 16),
          AlternativeOptions(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Zaloguj się',
      style: TextStyle(
        color: Colors.black,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
