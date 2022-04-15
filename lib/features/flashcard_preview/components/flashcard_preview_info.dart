import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
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
          children: const [
            ItemWithIcon(
              icon: MdiIcons.checkCircleOutline,
              label: 'Status',
              text: 'Zapamiętana',
              iconColor: Colors.green,
              textColor: Colors.green,
              paddingLeft: 8,
              paddingRight: 8,
            ),
            ItemWithIcon(
              icon: MdiIcons.archiveOutline,
              label: 'Kurs',
              text: 'Język angielski',
              paddingLeft: 8,
              paddingRight: 8,
            ),
            ItemWithIcon(
              icon: MdiIcons.folderOutline,
              label: 'Grupa',
              text: 'Budowa ciała',
              paddingLeft: 8,
              paddingRight: 8,
            ),
          ],
        );
      },
    );
  }
}
