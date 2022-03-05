import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/core/auth/auth_subscriber.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class AuthBlocProvider extends StatelessWidget {
  final Widget child;

  const AuthBlocProvider({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBloc>(
      create: (context) => AuthBloc(
        authInterface: context.read<AuthInterface>(),
        authSubscriber: AuthSubscriber(
          authInterface: context.read<AuthInterface>(),
        ),
      )..initialize(),
      child: child,
      dispose: (_, bloc) => bloc.dispose(),
    );
  }
}
