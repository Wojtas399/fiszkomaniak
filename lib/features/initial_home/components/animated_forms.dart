import 'package:fiszkomaniak/features/initial_home/components/animated_form.dart';
import 'package:fiszkomaniak/features/sign_in/sign_in_form.dart';
import 'package:fiszkomaniak/features/sign_up/sign_up_form.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/global_theme.dart';

class AnimatedForms extends StatelessWidget {
  const AnimatedForms({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);

    return Theme(
      data: GlobalTheme.lightTheme,
      child: Stack(
        children: [
          AnimatedForm(
            form: const SignInForm(),
            isVisible: initialHomeModeProvider.isLoginMode,
          ),
          AnimatedForm(
            form: const SignUpForm(),
            isVisible: initialHomeModeProvider.isRegisterMode,
          ),
        ],
      ),
    );
  }
}
