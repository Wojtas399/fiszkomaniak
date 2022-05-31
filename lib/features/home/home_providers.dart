import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications/sessions_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/injections/notifications_provider.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/notifications/notifications_bloc.dart';
import '../../injections/firebase_provider.dart';

class HomeProviders extends StatelessWidget {
  final Widget child;

  const HomeProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideUserInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideCoursesInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideGroupsInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideFlashcardsInterface(),
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (BuildContext context) => UserBloc(
              userInterface: context.read<UserInterface>(),
            )..add(UserEventInitialize()),
          ),
          BlocProvider(
            create: (BuildContext context) => AppearanceSettingsBloc(
              settingsInterface: context.read<SettingsInterface>(),
            )..add(AppearanceSettingsEventLoad()),
          ),
          BlocProvider(
            create: (BuildContext context) => NotificationsSettingsBloc(
              settingsInterface: context.read<SettingsInterface>(),
            )..add(NotificationsSettingsEventLoad()),
          ),
          BlocProvider<CoursesBloc>(
            create: (BuildContext context) => CoursesBloc(
              coursesInterface: context.read<CoursesInterface>(),
            )..add(CoursesEventInitialize()),
          ),
          BlocProvider<GroupsBloc>(
            create: (BuildContext context) => GroupsBloc(
              groupsInterface: context.read<GroupsInterface>(),
            )..add(GroupsEventInitialize()),
          ),
          BlocProvider<FlashcardsBloc>(
            create: (BuildContext context) => FlashcardsBloc(
              flashcardsInterface: context.read<FlashcardsInterface>(),
              groupsBloc: context.read<GroupsBloc>(),
            )..add(FlashcardsEventInitialize()),
          ),
          BlocProvider<SessionsBloc>(
            create: (BuildContext context) => SessionsBloc(
              sessionsInterface: context.read<SessionsInterface>(),
            )..add(SessionsEventInitialize()),
          ),
          BlocProvider<NotificationsBloc>(
            create: (BuildContext context) => NotificationsBloc(
              notificationsInterface: context.read<NotificationsInterface>(),
              notificationsSettingsBloc:
                  context.read<NotificationsSettingsBloc>(),
              sessionsNotificationsBloc: SessionsNotificationsBloc(
                sessionsNotificationsInterface:
                    context.read<SessionsNotificationsInterface>(),
                notificationsSettingsBloc:
                    context.read<NotificationsSettingsBloc>(),
                sessionsBloc: context.read<SessionsBloc>(),
                groupsBloc: context.read<GroupsBloc>(),
              ),
            )..add(NotificationsEventInitialize()),
          ),
        ],
        child: child,
      ),
    );
  }
}
