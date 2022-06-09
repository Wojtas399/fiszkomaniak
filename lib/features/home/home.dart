import 'package:fiszkomaniak/core/appearance_settings/appearance_settings_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:fiszkomaniak/features/home/home_error_screen.dart';
import 'package:fiszkomaniak/features/home/home_loading_screen.dart';
import 'package:fiszkomaniak/features/home/home_providers.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/initialization_status.dart';
import '../../core/sessions/sessions_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const HomeProviders(
        child: _View(),
      ),
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final InitializationStatus appearanceSettingsStatus = context.select(
      (AppearanceSettingsBloc bloc) => bloc.state.initializationStatus,
    );
    final InitializationStatus notificationsSettingsStatus = context.select(
      (NotificationsSettingsBloc bloc) => bloc.state.initializationStatus,
    );
    final InitializationStatus coursesInitializationStatus = context.select(
      (CoursesBloc bloc) => bloc.state.initializationStatus,
    );
    final InitializationStatus groupsInitializationStatus = context.select(
      (GroupsBloc bloc) => bloc.state.initializationStatus,
    );
    final InitializationStatus sessionsInitializationStatus = context.select(
      (SessionsBloc bloc) => bloc.state.initializationStatus,
    );
    final InitializationStatus loggedUserInitializationStatus = context.select(
      (UserBloc bloc) => bloc.state.initializationStatus,
    );
    final List<InitializationStatus> allStatuses = [
      appearanceSettingsStatus,
      notificationsSettingsStatus,
      coursesInitializationStatus,
      groupsInitializationStatus,
      sessionsInitializationStatus,
      loggedUserInitializationStatus,
    ];
    if (_isThereLoadingData(allStatuses)) {
      return const HomeLoadingScreen();
    } else if (_areAllDataReady(allStatuses)) {
      return const HomeRouter();
    }
    return const HomeErrorScreen();
  }

  bool _isThereLoadingData(List<InitializationStatus> statuses) {
    return statuses
        .where((status) => status == InitializationStatus.loading)
        .isNotEmpty;
  }

  bool _areAllDataReady(List<InitializationStatus> statuses) {
    return statuses
            .where((status) => status == InitializationStatus.ready)
            .length ==
        statuses.length;
  }
}
