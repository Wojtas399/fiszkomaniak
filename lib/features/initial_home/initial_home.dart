import 'package:fiszkomaniak/components/on_tap_focus_lose_area.dart';
import 'package:fiszkomaniak/features/initial_home/components/animated_form_card.dart';
import 'package:fiszkomaniak/features/initial_home/components/animated_forms.dart';
import 'package:fiszkomaniak/features/initial_home/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'components/color_mode_icon.dart';

class InitialHome extends StatelessWidget {
  const InitialHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OnTapFocusLoseArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: const _AppBar(),
        body: ChangeNotifierProvider(
          create: (_) => InitialHomeModeProvider(),
          builder: (context, _) {
            return const _Body();
          },
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(0);

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: themeProvider.isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      elevation: 0,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            _Logo(),
            AnimatedFormCard(
              child: AnimatedForms(),
            ),
          ],
        ),
        const ColorModeIcon(),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Container(
          width: 325,
          padding: const EdgeInsets.only(top: 40),
          child: Image.asset('assets/logo.png'),
        ),
      ),
    );
  }
}
