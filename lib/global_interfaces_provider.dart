import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'injections/firebase_provider.dart';

class GlobalInterfacesProvider extends StatelessWidget {
  final Widget child;

  const GlobalInterfacesProvider({Key? key, required this.child})
      : super(key: key);

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
      child: child,
    );
  }
}
