import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/models/flashcard_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FlashcardPreviewInfo extends StatelessWidget {
  const FlashcardPreviewInfo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardPreviewBloc, FlashcardPreviewState>(
      builder: (BuildContext context, FlashcardPreviewState state) {
        return Column(
          children: [
            ItemWithIcon(
              icon: MdiIcons.checkCircleOutline,
              label: 'Status',
              text: _getStatusName(state.flashcard?.status),
              iconColor: _getStatusColor(state.flashcard?.status),
              textColor: _getStatusColor(state.flashcard?.status),
              paddingLeft: 8,
              paddingRight: 8,
            ),
            ItemWithIcon(
              icon: MdiIcons.archiveOutline,
              label: 'Kurs',
              text: state.courseName,
              paddingLeft: 8,
              paddingRight: 8,
            ),
            ItemWithIcon(
              icon: MdiIcons.folderOutline,
              label: 'Grupa',
              text: state.group?.name ?? '',
              paddingLeft: 8,
              paddingRight: 8,
            ),
          ],
        );
      },
    );
  }

  String _getStatusName(FlashcardStatus? status) {
    switch (status) {
      case FlashcardStatus.remembered:
        return 'Zapamiętana';
      case FlashcardStatus.notRemembered:
        return 'Niezapamiętana';
      case null:
        return '--';
    }
  }

  Color? _getStatusColor(FlashcardStatus? status) {
    switch (status) {
      case FlashcardStatus.remembered:
        return Colors.green;
      case FlashcardStatus.notRemembered:
        return Colors.red;
      case null:
        return null;
    }
  }
}
