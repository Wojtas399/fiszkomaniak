import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import '../../../providers/theme_provider.dart';

class InitialHomeColorModeIcon extends StatelessWidget {
  const InitialHomeColorModeIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 40,
      right: 16,
      child: IconButton(
        onPressed: () {
          final themeProvider = context.read<ThemeProvider>();
          themeProvider.toggleTheme(!themeProvider.isDarkMode);
        },
        icon: const Icon(MdiIcons.shieldMoonOutline),
      ),
    );
  }
}
