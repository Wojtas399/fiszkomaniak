import 'package:fiszkomaniak/features/initial_home/components/initial_home_view.dart';
import 'package:fiszkomaniak/providers/auth/auth_bloc_provider.dart';
import 'package:fiszkomaniak/providers/auth/auth_interface_provider.dart';
import 'package:flutter/material.dart';

class InitialHome extends StatelessWidget {
  const InitialHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AuthInterfaceProvider(
      child: AuthBlocProvider(
        child: InitialHomeView(),
      ),
    );
  }
}
