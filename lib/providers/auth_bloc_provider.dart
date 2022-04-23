import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/auth/auth_bloc.dart';
import 'package:fiszkomaniak/interfaces/auth_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
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
        settingsInterface: context.read<SettingsInterface>(),
      )..initialize(
          onUserLogged: () {
            context.read<Navigation>().pushReplacementToHome(context);
          },
        ),
      child: child,
      dispose: (_, bloc) => bloc.dispose(),
    );
  }
}
