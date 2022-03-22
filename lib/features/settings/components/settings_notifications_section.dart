import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/features/settings/components/settings_switch.dart';
import 'package:fiszkomaniak/features/settings/components/switch_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/section.dart';

class SettingsNotificationsSection extends StatelessWidget {
  const SettingsNotificationsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext context, SettingsState state) {
        return Section(
          title: 'Powiadomienia',
          trailing: SettingsSwitch(
            isSwitched: state.areAllNotificationsOn,
            onSwitchChanged: (bool isSwitched) {
              context
                  .read<SettingsBloc>()
                  .add(SettingsEventNotificationsSettingsChanged(
                    areSessionsPlannedNotificationsOn: isSwitched,
                    areSessionsDefaultNotificationsOn: isSwitched,
                    areAchievementsNotificationsOn: isSwitched,
                    areLossOfDaysNotificationsOn: isSwitched,
                  ));
            },
          ),
          child: Column(
            children: [
              SwitchOptionItem(
                icon: MdiIcons.calendarCheckOutline,
                text: 'Sesje (zaplanowana godzina)',
                isSwitched: state
                    .notificationsSettings.areSessionsPlannedNotificationsOn,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventNotificationsSettingsChanged(
                        areSessionsPlannedNotificationsOn: isSwitched,
                      ));
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.calendarCheckOutline,
                text: 'Sesje (15 min przed)',
                isSwitched: state
                    .notificationsSettings.areSessionsDefaultNotificationsOn,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventNotificationsSettingsChanged(
                        areSessionsDefaultNotificationsOn: isSwitched,
                      ));
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.trophyOutline,
                text: 'Osiągnięcia',
                isSwitched:
                    state.notificationsSettings.areAchievementsNotificationsOn,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventNotificationsSettingsChanged(
                        areAchievementsNotificationsOn: isSwitched,
                      ));
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.medalOutline,
                text: 'Możliwa utrata dni',
                isSwitched:
                    state.notificationsSettings.areLossOfDaysNotificationsOn,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventNotificationsSettingsChanged(
                        areLossOfDaysNotificationsOn: isSwitched,
                      ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
