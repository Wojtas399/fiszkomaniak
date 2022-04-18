import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';

class SessionCreatorDatePicker extends StatelessWidget {
  const SessionCreatorDatePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.calendarOutline,
      label: 'Data',
      text: '--',
      paddingLeft: 8.0,
      paddingRight: 8.0,
      onTap: () {
        showDatePicker(
          context: context,
          confirmText: 'WYBIERZ',
          cancelText: 'ANULUJ',
          initialDate: DateTime.now(),
          lastDate: DateTime(2030, 12, 31),
          firstDate: DateTime.now(),
          locale: const Locale('pl', 'PL'),
        );
      },
    );
  }
}
