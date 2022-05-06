import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_event.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_event.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_event.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_event.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_event.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/core/user/user_event.dart';
import 'package:fiszkomaniak/interfaces/courses_interface.dart';
import 'package:fiszkomaniak/interfaces/flashcards_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/interfaces/settings_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/groups/groups_event.dart';
import '../../injections/firebase_provider.dart';

class HomeProviders extends StatelessWidget {
  final Widget child;

  const HomeProviders({Key? key, required this.child}) : super(key: key);

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
          BlocProvider(
            create: (BuildContext context) => SessionsBloc(
              sessionsInterface: context.read<SessionsInterface>(),
            )..add(SessionsEventInitialize()),
          ),
        ],
        child: child,
      ),
    );
  }
}
