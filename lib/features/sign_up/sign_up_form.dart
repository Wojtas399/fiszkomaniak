import 'package:fiszkomaniak/components/button.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InitialHomeModeProvider homeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    return Center(
      child: Button(
        label: 'Sign in',
        onPressed: () {
          homeModeProvider.changeMode(InitialHomeMode.login);
        },
      ),
    );
  }
}
