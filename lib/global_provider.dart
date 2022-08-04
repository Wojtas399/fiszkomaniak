import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'providers/firebase_provider.dart';

class GlobalProvider extends StatelessWidget {
  final Widget child;

  const GlobalProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideAuthInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideUserInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideAchievementsInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideSettingsInterface(),
        ),
      ],
      child: child,
    );
  }
}
