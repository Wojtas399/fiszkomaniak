import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/components/settings_switch_item_with_description.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/section.dart';

class SettingsAppearanceSection extends StatelessWidget {
  const SettingsAppearanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Section(
      displayDividerAtTheBottom: true,
      title: 'Wygląd',
      child: Column(
        children: const [
          _DarkModeSwitchItem(),
          _DarkModeCompatibilityWithSystemSwitchItem(),
          _SessionTimerInvisibilitySwitchItem(),
        ],
      ),
    );
  }
}

class _DarkModeSwitchItem extends StatelessWidget {
  const _DarkModeSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) => bloc.state.appearanceSettings.isDarkModeOn,
    );
    final bool isDisabled = context.select(
      (SettingsBloc bloc) =>
          bloc.state.appearanceSettings.isDarkModeCompatibilityWithSystemOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.shieldMoonOutline,
      text: 'Ciemny motyw',
      isSwitched: isSwitched,
      disabled: isDisabled,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventAppearanceSettingsChanged(
          isDarkModeOn: isSwitched,
        ));
  }
}

class _DarkModeCompatibilityWithSystemSwitchItem extends StatelessWidget {
  const _DarkModeCompatibilityWithSystemSwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) =>
          bloc.state.appearanceSettings.isDarkModeCompatibilityWithSystemOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.shieldSyncOutline,
      text: 'Motyw systemowy',
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventAppearanceSettingsChanged(
          isDarkModeCompatibilityWithSystemOn: isSwitched,
        ));
  }
}

class _SessionTimerInvisibilitySwitchItem extends StatelessWidget {
  const _SessionTimerInvisibilitySwitchItem();

  @override
  Widget build(BuildContext context) {
    final bool isSwitched = context.select(
      (SettingsBloc bloc) =>
          bloc.state.appearanceSettings.isSessionTimerInvisibilityOn,
    );
    return SettingsSwitchItemWithDescription(
      icon: MdiIcons.clockRemoveOutline,
      text: 'Ukryj czas podczas sesji',
      isSwitched: isSwitched,
      onSwitchChanged: (bool isSwitched) => _onChanged(isSwitched, context),
    );
  }

  void _onChanged(bool isSwitched, BuildContext context) {
    context.read<SettingsBloc>().add(SettingsEventAppearanceSettingsChanged(
          isSessionTimerInvisibilityOn: isSwitched,
        ));
  }
}
