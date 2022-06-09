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
              await Dialogs.showAchievementDialog(
                  achievementValue: status.newDaysStreak,
                  title: 'Dni nauki z rzędu',
                  textBeforeAchievementValue: 'Właśnie ukończyłeś',
                  textAfterAchievementValue: 'dni nauki z rzędu. Gratulacje!');
            } else if (status is AchievementsStatusNewConditionCompleted) {
              Dialogs.closeLoadingDialog(context);
              switch (status.achievementType) {
                case AchievementType.amountOfAllFlashcards:
                  await Dialogs.showAchievementDialog(
                    achievementValue: status.completedConditionValue,
                    title: 'Utworzone fiszki',
                    textBeforeAchievementValue: 'Dotychczas utworzyłeś ponad',
                    textAfterAchievementValue: 'fiszek. Gratulacje!',
                  );
                  break;
                case AchievementType.amountOfRememberedFlashcards:
                  await Dialogs.showAchievementDialog(
                    achievementValue: status.completedConditionValue,
                    title: 'Zapamiętane fiszki',
                    textBeforeAchievementValue: 'Dotychczas zapamiętałeś ponad',
                    textAfterAchievementValue: 'fiszek. Gratulacje!',
                  );
                  break;
                case AchievementType.amountOfFinishedSessions:
                  await Dialogs.showAchievementDialog(
                    achievementValue: status.completedConditionValue,
                    title: 'Ukończone sesje',
                    textBeforeAchievementValue: 'Dotychczas ukończyłeś ponad',
                    textAfterAchievementValue: 'sesji. Gratulacje!',
                  );
                  break;
              }
            }
          },
        );
}
