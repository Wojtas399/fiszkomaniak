import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/sign_in/bloc/sign_in_bloc.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../bloc/sign_in_event.dart';
import '../bloc/sign_in_state.dart';

class AlternativeOptions extends StatelessWidget {
  const AlternativeOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignInBloc, SignInState>(
      builder: (context, state) {
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
      },
    );
  }

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
}

class _SignUpOption extends StatelessWidget {
  final TextStyle textStyle;

  const _SignUpOption({Key? key, required this.textStyle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    return GestureDetector(
      onTap: () {
        initialHomeModeProvider.changeMode(InitialHomeMode.register);
        Utils.unfocusElements();
        context.read<SignInBloc>().add(SignInEventReset());
      },
      child: Text('Nie masz konta? Zarejestruj się!', style: textStyle),
    );
  }
}

class _PasswordRecoveryOption extends StatelessWidget {
  final TextStyle textStyle;

  const _PasswordRecoveryOption({
    Key? key,
    required this.textStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigation.navigateToResetPassword(context);
      },
      child: Text('Zapomniałeś hasła?', style: textStyle),
    );
  }
}
