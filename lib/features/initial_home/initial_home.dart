import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../config/navigation.dart';
import '../../domain/use_cases/auth/is_user_logged_use_case.dart';
import '../../interfaces/auth_interface.dart';
import 'bloc/initial_home_bloc.dart';
import 'components/initial_home_content.dart';

class InitialHome extends StatelessWidget {
  const InitialHome({super.key});

  @override
  Widget build(BuildContext context) {
    return const _InitialHomeBlocProvider(
      child: _InitialHomeBlocListener(
        child: InitialHomeContent(),
      ),
    );
  }
}

class _InitialHomeBlocProvider extends StatelessWidget {
  final Widget child;

  const _InitialHomeBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => InitialHomeBloc(
        isUserLoggedUseCase: IsUserLoggedUseCase(
          authInterface: context.read<AuthInterface>(),
        ),
      )..add(InitialHomeEventInitialize()),
      child: child,
    );
  }
}

class _InitialHomeBlocListener extends StatelessWidget {
  final Widget child;

  const _InitialHomeBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitialHomeBloc, InitialHomeState>(
      listener: (BuildContext context, InitialHomeState state) {
        if (state.isUserLogged) {
          Navigation.pushReplacementToHome(context);
        }
      },
      child: child,
    );
  }
}
