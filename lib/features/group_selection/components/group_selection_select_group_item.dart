import 'package:fiszkomaniak/components/select_item/select_item.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupSelectionSelectGroupItem extends StatelessWidget {
  const GroupSelectionSelectGroupItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectItem(
      icon: MdiIcons.folderOutline,
      label: 'Grupa',
      value: 'Nie wybrano',
      optionsListTitle: 'Wybierz grupę',
      options: const {
        'option1': 'Opcja1',
        'option2': 'Opcja2',
        'option3': 'Opcja3',
      },
      onOptionSelected: (String key, String value) {
        print('Selected group: $value');
      },
    );
  }
}
