import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../converters/flashcards_type_converters.dart';
import 'item_with_icon.dart';
import 'modal_bottom_sheet.dart';

class FlashcardsTypePicker extends StatelessWidget {
  final FlashcardsType selectedType;
  final List<FlashcardsType> availableTypes;
  final Function(FlashcardsType type)? onTypeChanged;

  const FlashcardsTypePicker({
    Key? key,
    required this.selectedType,
    required this.availableTypes,
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
          title: 'Wybierz rodzaj fiszek',
          options: _buildOptions(),
        );
        _changeFlashcardsType(context, selectedOption);
      },
    );
  }

  List<ModalBottomSheetOption> _buildOptions() {
    List<ModalBottomSheetOption> options = [];
    for (final type in FlashcardsType.values) {
      if (availableTypes.contains(type)) {
        options.add(ModalBottomSheetOption(
          icon: _getAppropriateIcon(type),
          text: convertFlashcardsTypeToViewFormat(type),
        ));
      }
    }
    return options;
  }

  IconData _getAppropriateIcon(FlashcardsType type) {
    switch (type) {
      case FlashcardsType.all:
        return MdiIcons.cardsOutline;
      case FlashcardsType.remembered:
        return MdiIcons.checkCircleOutline;
      case FlashcardsType.notRemembered:
        return MdiIcons.closeCircleOutline;
    }
  }

  void _changeFlashcardsType(BuildContext context, int? selectedOption) {
    FlashcardsType? type;
    if (selectedOption == 0) {
      type = availableTypes[0];
    } else if (selectedOption == 1) {
      type = availableTypes[1];
    } else if (selectedOption == 2) {
      type = availableTypes[2];
    }
    if (type != null && onTypeChanged != null) {
      onTypeChanged!(type);
    }
  }
}
