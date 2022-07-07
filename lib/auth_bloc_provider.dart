import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBlocProvider extends StatelessWidget {
  final Widget child;

  const AuthBlocProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AuthBloc(
        authInterface: context.read<AuthInterface>(),
      )..add(AuthEventInitialize()),
      child: child,
    );
  }
}
