import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/modal_bottom_sheet_options.dart';

class SessionCreatorFlashcardsTypePicker extends StatelessWidget {
  const SessionCreatorFlashcardsTypePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.cardsOutline,
      label: 'Rodzaj',
      text: 'Wszystkie',
      paddingLeft: 8.0,
      paddingRight: 8.0,
      onTap: () async {
        final int? selectedOption = await ModalBottomSheet.showWithOptions(
          context: context,
          title: 'Wybierz rodzaj fiszek',
          options: [
            ModalBottomSheetOption(
              icon: MdiIcons.cards,
              text: 'Wszystkie',
            ),
            ModalBottomSheetOption(
              icon: MdiIcons.checkCircle,
              text: 'Zapamiętane',
            ),
            ModalBottomSheetOption(
              icon: MdiIcons.closeCircle,
              text: 'Niezapamiętane',
            ),
          ],
        );
        print(selectedOption);
      },
    );
  }
}
