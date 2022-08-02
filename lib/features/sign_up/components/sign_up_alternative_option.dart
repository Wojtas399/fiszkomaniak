import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../utils/utils.dart';
import '../../initial_home/bloc/initial_home_bloc.dart';
import '../bloc/sign_up_bloc.dart';

class SignUpAlternativeOption extends StatelessWidget {
  const SignUpAlternativeOption({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: GestureDetector(
          onTap: () => _onPressed(context),
          child: const Text(
            'Masz już konto? Zaloguj się!',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  void _onPressed(BuildContext context) {
    context.read<InitialHomeBloc>().add(
          InitialHomeEventChangeMode(mode: InitialHomeMode.login),
        );
    Utils.unfocusElements();
    context.read<SignUpBloc>().add(SignUpEventReset());
  }
}
