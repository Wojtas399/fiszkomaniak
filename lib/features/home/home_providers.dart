import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/notifications/achievements_notifications_bloc.dart';
import 'package:fiszkomaniak/core/notifications/sessions_notifications_bloc.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/update_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/injections/notifications_provider.dart';
import 'package:fiszkomaniak/interfaces/achievements_interface.dart';
import 'package:fiszkomaniak/interfaces/achievements_notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_interface.dart';
import 'package:fiszkomaniak/interfaces/sessions_notifications_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/notifications/notifications_bloc.dart';
import '../../domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
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
          create: (_) => FirebaseProvider.provideSessionsInterface(),
        ),
        RepositoryProvider(
          create: (_) => NotificationsProvider.provideNotificationsInterface(),
        ),
        RepositoryProvider(
          create: (_) => FirebaseProvider.provideAchievementsInterface(),
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
          BlocProvider(
            create: (BuildContext context) => AppearanceSettingsBloc(
              getAppearanceSettingsUseCase: GetAppearanceSettingsUseCase(
                appearanceSettingsInterface:
                    context.read<AppearanceSettingsInterface>(),
              ),
              updateAppearanceSettingsUseCase: UpdateAppearanceSettingsUseCase(
                appearanceSettingsInterface:
                    context.read<AppearanceSettingsInterface>(),
              ),
            )..add(AppearanceSettingsEventLoad()),
          ),
          BlocProvider<SessionsBloc>(
            create: (BuildContext context) => SessionsBloc(
              sessionsInterface: context.read<SessionsInterface>(),
            )..add(SessionsEventInitialize()),
          ),
          BlocProvider<AchievementsBloc>(
            create: (BuildContext context) => AchievementsBloc(
              achievementsInterface: context.read<AchievementsInterface>(),
            )..add(AchievementsEventInitialize()),
          ),
          BlocProvider<NotificationsBloc>(
            create: (BuildContext context) => NotificationsBloc(
              notificationsInterface: context.read<NotificationsInterface>(),
              sessionsNotificationsBloc: SessionsNotificationsBloc(
                sessionsNotificationsInterface:
                    context.read<SessionsNotificationsInterface>(),
                sessionsBloc: context.read<SessionsBloc>(),
              ),
              achievementsNotificationsBloc: AchievementsNotificationsBloc(
                achievementsNotificationsInterface:
                    context.read<AchievementsNotificationsInterface>(),
                achievementsBloc: context.read<AchievementsBloc>(),
              ),
            )..add(NotificationsEventInitialize()),
          ),
        ],
        child: child,
      ),
    );
  }
}
