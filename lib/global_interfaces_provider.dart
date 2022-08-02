import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'providers/firebase_provider.dart';

class GlobalInterfacesProvider extends StatelessWidget {
  final Widget child;

  const GlobalInterfacesProvider({super.key, required this.child});

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
          create: (_) => FirebaseProvider.provideAppearanceSettingsInterface(),
        ),
        RepositoryProvider(
          create: (_) =>
              FirebaseProvider.provideNotificationsSettingsInterface(),
        ),
      ],
      child: child,
    );
  }
}
