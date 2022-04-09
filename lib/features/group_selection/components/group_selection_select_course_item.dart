import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/select_item/select_item.dart';

class GroupSelectionSelectCourseItem extends StatelessWidget {
  const GroupSelectionSelectCourseItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SelectItem(
      icon: MdiIcons.archiveOutline,
      label: 'Kurs',
      value: 'Nie wybrano',
      optionsListTitle: 'Wybierz kurs',
      options: const {
        'option1': 'Opcja1',
        'option2': 'Opcja2',
        'option3': 'Opcja3',
      },
      onOptionSelected: (String key, String value) {
        print('Selected course: $value');
      },
    );
  }
}
