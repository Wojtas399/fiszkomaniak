import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_bloc.dart';
import 'package:fiszkomaniak/features/flashcard_preview/bloc/flashcard_preview_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../../components/app_bar_with_close_button.dart';

class FlashcardPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FlashcardPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardPreviewBloc, FlashcardPreviewState>(
      builder: (BuildContext context, FlashcardPreviewState state) {
        return AppBarWithCloseButton(
          label: 'Fiszka',
          actions: [
            CustomIconButton(
              icon: MdiIcons.delete,
              onPressed: () {
                //TODO
              },
            ),
          ],
        );
      },
    );
  }
}
