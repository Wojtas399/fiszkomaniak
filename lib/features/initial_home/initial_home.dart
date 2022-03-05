import 'package:fiszkomaniak/features/sign_in/sign_in_screen.dart';
import 'package:fiszkomaniak/providers/auth/auth_bloc_provider.dart';
import 'package:fiszkomaniak/providers/auth/auth_interface_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InitialHome extends StatelessWidget {
  const InitialHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthInterfaceProvider(
      child: AuthBlocProvider(
        child: SignInScreen(),
      ),
    );
  }
}
