import 'package:fiszkomaniak/components/app_bar_with_search_text_field.dart';
import 'package:flutter/material.dart';

class FlashcardsPreviewAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const FlashcardsPreviewAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBarWithSearchTextField(
      label: 'Fiszka',
      onChanged: (String value) {},
    );
  }
}
