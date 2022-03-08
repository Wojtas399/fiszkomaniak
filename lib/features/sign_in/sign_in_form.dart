import 'package:flutter/material.dart';
import '../../components/button.dart';
import 'components/sign_in_alternative_options.dart';
import 'components/sign_in_inputs.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _Header(),
        const SizedBox(height: 24),
        const SignInInputs(),
        const SizedBox(height: 8),
        Button(
          label: 'Zaloguj',
          onPressed: () {},
        ),
        const SizedBox(height: 16),
        const AlternativeOptions(),
      ],
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
