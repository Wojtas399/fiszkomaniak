import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/notifications/achievements_notifications_bloc.dart';
import '../../core/notifications/sessions_notifications_bloc.dart';
import '../../core/notifications/notifications_bloc.dart';
import '../../injections/notifications_provider.dart';
import '../../injections/firebase_provider.dart';
import '../../interfaces/achievements_notifications_interface.dart';
import '../../interfaces/notifications_interface.dart';
import '../../interfaces/sessions_notifications_interface.dart';

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
        RepositoryProvider(
          create: (_) =>
              NotificationsProvider.provideSessionsNotificationsInterface(),
        ),
        RepositoryProvider(
          create: (_) =>
              NotificationsProvider.provideAchievementsNotificationsInterface(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NotificationsBloc>(
            create: (BuildContext context) => NotificationsBloc(
              notificationsInterface: context.read<NotificationsInterface>(),
              sessionsNotificationsBloc: SessionsNotificationsBloc(
                sessionsNotificationsInterface:
                    context.read<SessionsNotificationsInterface>(),
              ),
              achievementsNotificationsBloc: AchievementsNotificationsBloc(
                achievementsNotificationsInterface:
                    context.read<AchievementsNotificationsInterface>(),
              ),
            )..add(NotificationsEventInitialize()),
          ),
        ],
        child: child,
      ),
    );
  }
}
