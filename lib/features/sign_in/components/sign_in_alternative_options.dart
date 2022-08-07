import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../config/navigation.dart';
import '../../../features/initial_home/bloc/initial_home_bloc.dart';
import '../../../utils/utils.dart';
import '../bloc/sign_in_bloc.dart';

class AlternativeOptions extends StatelessWidget {
  const AlternativeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _SignUpOption(textStyle: _textStyle),
          const SizedBox(height: 16),
          _PasswordRecoveryOption(textStyle: _textStyle),
        ],
      ),
    );
  }

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
}

class _SignUpOption extends StatelessWidget {
  final TextStyle textStyle;

  const _SignUpOption({required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onPressed(context),
      child: Text('Nie masz konta? Zarejestruj się!', style: textStyle),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<InitialHomeBloc>().add(
          InitialHomeEventChangeMode(mode: InitialHomeMode.register),
        );
    Utils.unfocusElements();
    context.read<SignInBloc>().add(SignInEventReset());
  }
}

class _PasswordRecoveryOption extends StatelessWidget {
  final TextStyle textStyle;

  const _PasswordRecoveryOption({required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _onPressed(context),
      child: Text('Zapomniałeś hasła?', style: textStyle),
    );
  }

  void _onPressed(BuildContext context) {
    Navigation.navigateToResetPassword(context);
  }
}
