import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/switch_item.dart';
import '../../../features/settings/bloc/settings_bloc.dart';
import '../../../features/settings/components/settings_switch_item_with_description.dart';
import '../../../components/section.dart';

class SettingsNotificationsSection extends StatelessWidget {
  const SettingsNotificationsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Powiadomienia',
      trailing: const _AllNotificationsSwitchItem(),
      child: Column(
        children: const [
          _ScheduledSessionsSwitchItem(),
          _DefaultSessionsSwitchItem(),
          _AchievementsSwitchItem(),
          _LossOfDaysStreakSwitchItem(),
        ],
      ),
    );
  }
}

class _AllNotificationsSwitchItem extends StatelessWidget {
  const _AllNotificationsSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) => bloc.state.areAllNotificationsOn,
    );
    return SwitchItem(
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventNotificationsSettingsChanged(
          areSessionsScheduledNotificationsOn: isSwitched,
          areSessionsDefaultNotificationsOn: isSwitched,
          areAchievementsNotificationsOn: isSwitched,
          areLossOfDaysStreakNotificationsOn: isSwitched,
        ));
  }
}

class _ScheduledSessionsSwitchItem extends StatelessWidget {
  const _ScheduledSessionsSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) =>
          bloc.state.notificationsSettings.areSessionsScheduledNotificationsOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.calendarCheckOutline,
      text: 'Sesje (zaplanowana godzina)',
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventNotificationsSettingsChanged(
          areSessionsScheduledNotificationsOn: isSwitched,
        ));
  }
}

class _DefaultSessionsSwitchItem extends StatelessWidget {
  const _DefaultSessionsSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) =>
          bloc.state.notificationsSettings.areSessionsDefaultNotificationsOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.calendarCheckOutline,
      text: 'Sesje (15 min przed)',
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventNotificationsSettingsChanged(
          areSessionsDefaultNotificationsOn: isSwitched,
        ));
  }
}

class _AchievementsSwitchItem extends StatelessWidget {
  const _AchievementsSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) =>
          bloc.state.notificationsSettings.areAchievementsNotificationsOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.trophyOutline,
      text: 'Osiągnięcia',
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventNotificationsSettingsChanged(
          areAchievementsNotificationsOn: isSwitched,
        ));
  }
}

class _LossOfDaysStreakSwitchItem extends StatelessWidget {
  const _LossOfDaysStreakSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) =>
          bloc.state.notificationsSettings.areLossOfDaysStreakNotificationsOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.medalOutline,
      text: 'Możliwa utrata dni',
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventNotificationsSettingsChanged(
          areLossOfDaysStreakNotificationsOn: isSwitched,
        ));
  }
}
