import 'package:fiszkomaniak/features/home/listeners/achievements_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/auth_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/sessions_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import 'listeners/notifications_bloc_listener.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;
  final Dialogs dialogs = Dialogs();

  HomeListeners({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        AuthBlocListener(),
        SessionsBlocListener(onHomePageChanged: (int pageNumber) {}),
        NotificationsBlocListener(),
        AchievementsBlocListener(),
      ],
      child: child,
    );
  }
}
