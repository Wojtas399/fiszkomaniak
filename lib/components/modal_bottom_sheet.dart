import 'package:fiszkomaniak/components/item_with_icon.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ModalBottomSheet {
  static Future<int?> showWithOptions({
    String title = '',
    List<ModalBottomSheetOption> options = const [],
  }) async {
    final BuildContext? context = navigatorKey.currentContext;
    if (context != null) {
      return await showModalBottomSheet<int>(
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: [
              Container(
                color: Theme.of(context).dialogBackgroundColor,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 8.0,
                    top: 24.0,
                    bottom: 72.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Column(children: _buildOptions(context, options)),
                      ItemWithIcon(
                        icon: MdiIcons.close,
                        text: 'Anuluj',
                        onTap: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    return null;
  }

  static List<Widget> _buildOptions(
    BuildContext context,
    List<ModalBottomSheetOption> options,
  ) {
    return options
        .asMap()
        .entries
        .map((option) => ItemWithIcon(
              icon: option.value.icon,
              text: option.value.text,
              onTap: () {
                Navigator.pop(context, option.key);
              },
            ))
        .toList();
  }
}

class ModalBottomSheetOption {
  final IconData icon;
  final String text;

  ModalBottomSheetOption({
    required this.icon,
    required this.text,
  });
}
