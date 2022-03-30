import 'package:fiszkomaniak/components/textfields/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class GroupCreatorGroupInfo extends StatelessWidget {
  const GroupCreatorGroupInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CustomTextField(
          icon: MdiIcons.folder,
          label: 'Nazwa grupy fiszek',
        ),
        CustomTextField(
          icon: MdiIcons.file,
          label: 'Nazwa dla pytań',
        ),
        CustomTextField(
          icon: MdiIcons.fileReplace,
          label: 'Nazwa dla odpowiedzi',
        ),
      ],
    );
  }
}
