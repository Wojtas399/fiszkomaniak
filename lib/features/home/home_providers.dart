import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../providers/notifications_provider.dart';
import '../../providers/firebase_provider.dart';

class HomeProviders extends StatelessWidget {
  final Widget child;

  const HomeProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideCoursesInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideGroupsInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideSessionsInterface(),
        ),
        RepositoryProvider(
          create: (_) => NotificationsProvider.provideNotificationsInterface(),
        ),
      ],
      child: child,
    );
  }
}
