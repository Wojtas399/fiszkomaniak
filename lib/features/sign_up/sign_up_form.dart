import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_alternative_option.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_inputs.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_submit_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => SignUpBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Header(),
          SizedBox(height: 24),
          SignUpInputs(),
          SizedBox(height: 8),
          SignUpSubmitButton(),
          SizedBox(height: 16),
          SignUpAlternativeOption(),
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
      'Zarejestruj się',
      style: TextStyle(
        color: Colors.black,
        fontSize: 34,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
