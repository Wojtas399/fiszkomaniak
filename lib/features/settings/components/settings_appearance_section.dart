import 'package:fiszkomaniak/features/settings/bloc/settings_bloc.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_event.dart';
import 'package:fiszkomaniak/features/settings/bloc/settings_state.dart';
import 'package:fiszkomaniak/features/settings/components/switch_option_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/section.dart';

class SettingsAppearanceSection extends StatelessWidget {
  const SettingsAppearanceSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (BuildContext context, SettingsState state) {
        return Section(
          displayDividerAtTheBottom: true,
          title: 'Wygląd',
          child: Column(
            children: [
              SwitchOptionItem(
                icon: MdiIcons.shieldMoonOutline,
                text: 'Ciemny motyw',
                isSwitched: state.isDarkMode,
                onSwitchChanged: (bool isSwitched) {
                  context
                      .read<SettingsBloc>()
                      .add(SettingsEventDarkModeChanged());
                },
              ),
              SwitchOptionItem(
                icon: MdiIcons.clockRemoveOutline,
                text: 'Ukryj czas podczas sesji',
                onSwitchChanged: (bool isSwitched) {
                  print(isSwitched);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
