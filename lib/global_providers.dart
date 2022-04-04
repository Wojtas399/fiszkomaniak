import 'package:fiszkomaniak/providers/auth_bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injections/firebase_provider.dart';

class GlobalProviders extends StatelessWidget {
  final Widget child;

  const GlobalProviders({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideAuthInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideSettingsInterface(),
        ),
      ],
      child: AuthBlocProvider(
        child: child,
      ),
    );
  }
}
