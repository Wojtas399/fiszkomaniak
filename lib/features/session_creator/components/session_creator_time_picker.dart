import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';

class SessionCreatorTimePicker extends StatelessWidget {
  const SessionCreatorTimePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.clockStart,
      label: 'Godzina rozpoczęcia',
      text: '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
          cancelText: 'ANULUJ',
          confirmText: 'WYBIERZ',
          helpText: 'WYBIERZ GODZINĘ ROZPOCZĘCIA',
          builder: (BuildContext context, Widget? child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                alwaysUse24HourFormat: true,
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}
