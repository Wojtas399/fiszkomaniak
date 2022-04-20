import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../converters/flashcards_type_converter.dart';
import 'item_with_icon.dart';
import 'modal_bottom_sheet_options.dart';

class SessionFlashcardsTypePicker extends StatelessWidget {
  final FlashcardsType selectedType;
  final Function(FlashcardsType type)? onTypeChanged;

  const SessionFlashcardsTypePicker({
    Key? key,
    required this.selectedType,
    this.onTypeChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ItemWithIcon(
      icon: MdiIcons.cardsOutline,
      label: 'Rodzaj fiszek',
      text: convertFlashcardsTypeToViewFormat(selectedType),
      paddingLeft: 8.0,
      paddingRight: 8.0,
      onTap: () async {
        final int? selectedOption = await ModalBottomSheet.showWithOptions(
          context: context,
          title: 'Wybierz rodzaj fiszek',
          options: _buildOptions(),
        );
        _changeFlashcardsType(context, selectedOption);
      },
    );
  }

  List<ModalBottomSheetOption> _buildOptions() {
    return [
      ModalBottomSheetOption(
        icon: MdiIcons.cards,
        text: convertFlashcardsTypeToViewFormat(FlashcardsType.all),
      ),
      ModalBottomSheetOption(
        icon: MdiIcons.checkCircle,
        text: convertFlashcardsTypeToViewFormat(FlashcardsType.remembered),
      ),
      ModalBottomSheetOption(
        icon: MdiIcons.closeCircle,
        text: convertFlashcardsTypeToViewFormat(FlashcardsType.notRemembered),
      ),
    ];
  }

  void _changeFlashcardsType(BuildContext context, int? selectedOption) {
    FlashcardsType? type;
    if (selectedOption == 0) {
      type = FlashcardsType.all;
    } else if (selectedOption == 1) {
      type = FlashcardsType.remembered;
    } else if (selectedOption == 2) {
      type = FlashcardsType.notRemembered;
    }
    if (type != null && onTypeChanged != null) {
      onTypeChanged!(type);
    }
  }
}
