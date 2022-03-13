import 'package:fiszkomaniak/injections/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthInterfaceProvider extends StatelessWidget {
  final Widget child;

  const AuthInterfaceProvider({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => FirebaseProvider.provideAuthInterface(),
      child: child,
    );
  }
}
