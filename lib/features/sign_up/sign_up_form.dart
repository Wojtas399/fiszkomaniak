import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_alternative_option.dart';
import 'package:fiszkomaniak/features/sign_up/components/sign_up_inputs.dart';
import 'package:flutter/material.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 32,
        right: 32,
        top: 32,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Header(),
          const SizedBox(height: 24),
          const SignUpInputs(),
          const SizedBox(height: 32),
          Button(
            label: 'Zarejestruj',
            onPressed: () {},
          ),
          const SizedBox(height: 16),
          const SignUpAlternativeOption(),
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
