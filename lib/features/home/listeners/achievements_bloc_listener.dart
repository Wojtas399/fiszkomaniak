import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/core/achievements/achievements_bloc.dart';
import 'package:fiszkomaniak/core/notifications_settings/notifications_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AchievementsBlocListener
    extends BlocListener<AchievementsBloc, AchievementsState> {
  AchievementsBlocListener({super.key})
      : super(
          listener: (BuildContext context, AchievementsState state) async {
            final AchievementsStatus status = state.status;
            final bool areAchievementsNotificationsEnabled = context
                .read<NotificationsSettingsBloc>()
                .state
                .areAchievementsNotificationsOn;
            if (status is AchievementsStatusDaysStreakUpdated &&
                areAchievementsNotificationsEnabled) {
              Dialogs.closeLoadingDialog(context);
              await Dialogs.showDaysStreakDialog(context, status.newDaysStreak);
            }
          },
        );
}
