import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../config/theme/global_theme.dart';
import '../../../features/sign_in/sign_in_form.dart';
import '../../../features/sign_up/sign_up_form.dart';
import '../bloc/initial_home_bloc.dart';

class InitialHomeAnimatedForms extends StatelessWidget {
  const InitialHomeAnimatedForms({super.key});

  @override
  Widget build(BuildContext context) {
    final InitialHomeMode mode = context.select(
      (InitialHomeBloc bloc) => bloc.state.mode,
    );
    return Theme(
      data: GlobalTheme.lightTheme,
      child: (() {
        switch (mode) {
          case InitialHomeMode.login:
            return const SignInForm();
          case InitialHomeMode.register:
            return const SignUpForm();
        }
      }()),
    );
  }
}
