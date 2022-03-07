import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class ColorModeIcon extends StatelessWidget {
  const ColorModeIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 16,
      child: IconButton(
        onPressed: () {
          final themeProvider = Provider.of<ThemeProvider>(
            context,
            listen: false,
          );
          themeProvider.toggleTheme(!themeProvider.isDarkMode);
        },
        icon: const Icon(MdiIcons.shieldMoonOutline),
      ),
    );
  }
}
