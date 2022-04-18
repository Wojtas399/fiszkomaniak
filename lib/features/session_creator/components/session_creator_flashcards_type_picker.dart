import 'package:fiszkomaniak/converters/flashcards_type_converter.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_bloc.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_event.dart';
import 'package:fiszkomaniak/features/session_creator/bloc/session_creator_state.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/item_with_icon.dart';
import '../../../components/modal_bottom_sheet_options.dart';

class SessionCreatorFlashcardsTypePicker extends StatelessWidget {
  const SessionCreatorFlashcardsTypePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionCreatorBloc, SessionCreatorState>(
      builder: (BuildContext context, SessionCreatorState state) {
        return ItemWithIcon(
          icon: MdiIcons.cardsOutline,
          label: 'Rodzaj',
          text: convertFlashcardsTypeToViewFormat(state.flashcardsType),
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
    if (type != null) {
      context
          .read<SessionCreatorBloc>()
          .add(SessionCreatorEventFlashcardsTypeSelected(type: type));
    }
  }
}
