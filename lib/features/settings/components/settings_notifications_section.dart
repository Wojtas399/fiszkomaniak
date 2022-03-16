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
            isSwitched: state.areAllNotifications,
            onSwitchChanged: (bool isSwitched) {
              context
                  .read<SettingsBloc>()
                  .add(SettingsEventAllNotificationsChanged());
            },
          ),
          child: Column(
            children: [
              SwitchOptionItem(
                icon: MdiIcons.calendarCheckOutline,
                text: 'Sesje (zaplanowana godzina)',
                isSwitched: state.arePlannedSessionsNotifications,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventPlannedSessionsNotificationsChanged());
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.calendarCheckOutline,
                text: 'Sesje (15 min przed)',
                isSwitched: state.areDefaultSessionsNotifications,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventDefaultSessionsNotificationsChanged());
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.trophyOutline,
                text: 'Osiągnięcia',
                isSwitched: state.areAchievementsNotifications,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventAchievementNotificationsChanged());
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.medalOutline,
                text: 'Możliwa utrata dni',
                isSwitched: state.areDaysNotifications,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventDaysNotificationsChanged());
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
