import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/components/section.dart';
import 'package:fiszkomaniak/components/select_item/select_item.dart';
import 'package:fiszkomaniak/features/session_creator/components/session_creator_flashcards_type_picker.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SessionCreatorFlashcards extends StatelessWidget {
  const SessionCreatorFlashcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Section(
      title: 'Fiszki',
      displayDividerAtTheBottom: true,
      child: Stack(
        children: [
          Column(
            children: [
              SelectItem(
                icon: MdiIcons.archiveOutline,
                value: '--',
                label: 'Kurs',
                optionsListTitle: 'Wybierz kurs',
                options: const {
                  'option1': 'opcja1',
                  'option2': 'opcja2',
                },
                onOptionSelected: (String key, String value) {},
              ),
              SelectItem(
                icon: MdiIcons.folderOutline,
                value: '--',
                label: 'Grupa',
                optionsListTitle: 'Wybierz grupę',
                options: const {
                  'option1': 'opcja1',
                  'option2': 'opcja2',
                },
                onOptionSelected: (String key, String value) {},
              ),
              const SessionCreatorFlashcardsTypePicker(),
              const ItemWithIcon(
                icon: MdiIcons.fileOutline,
                label: 'Nazwa dla pytań',
                text: '--',
                paddingLeft: 8.0,
                paddingRight: 8.0,
              ),
              const ItemWithIcon(
                icon: MdiIcons.fileReplaceOutline,
                label: 'Nazwa dla odpowiedzi',
                text: '--',
                paddingLeft: 8.0,
                paddingRight: 8.0,
              ),
            ],
          ),
          Positioned(
            right: 0.0,
            bottom: 50.0,
            child: CustomIconButton(
              icon: MdiIcons.swapVertical,
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
