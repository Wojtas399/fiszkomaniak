import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpAlternativeOption extends StatelessWidget {
  const SignUpAlternativeOption({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: GestureDetector(
          onTap: () {
            initialHomeModeProvider.changeMode(InitialHomeMode.login);
            Utils.unfocusElements();
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
  }
}
