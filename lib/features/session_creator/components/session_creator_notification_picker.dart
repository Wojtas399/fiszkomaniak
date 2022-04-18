import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';

class SessionCreatorNotificationPicker extends StatelessWidget {
  const SessionCreatorNotificationPicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.bellRingOutline,
      label: 'Godzina przypomnienia',
      text: '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
      onTap: () {
        showTimePicker(
          context: context,
          initialTime: const TimeOfDay(hour: 0, minute: 0),
          cancelText: 'ANULUJ',
          confirmText: 'WYBIERZ',
          helpText: 'WYBIERZ GODZINĘ PRZYPOMNIENIA',
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
