import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_bloc.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_event.dart';
import 'package:fiszkomaniak/features/sign_up/bloc/sign_up_state.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class SignUpAlternativeOption extends StatelessWidget {
  const SignUpAlternativeOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    return BlocBuilder<SignUpBloc, SignUpState>(
      builder: (context, _) {
        return SizedBox(
          width: double.infinity,
          child: Center(
            child: GestureDetector(
              onTap: () {
                initialHomeModeProvider.changeMode(InitialHomeMode.login);
                Utils.unfocusElements();
                context.read<SignUpBloc>().add(SignUpEventReset());
              },
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
      },
    );
  }
}
