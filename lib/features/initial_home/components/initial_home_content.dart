import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../components/on_tap_focus_lose_area.dart';
import '../../../providers/theme_provider.dart';
import 'initial_home_animated_form_card.dart';
import 'initial_home_animated_forms.dart';
import 'initial_home_color_mode_icon.dart';

class InitialHomeContent extends StatelessWidget {
  const InitialHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return const OnTapFocusLoseArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: _AppBar(),
        body: _Body(),
      ),
    );
  }
}

class _AppBar extends StatelessWidget implements PreferredSizeWidget {
  const _AppBar();

  @override
  Size get preferredSize => const Size.fromHeight(0);

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = context.select(
      (ThemeProvider provider) => provider.isDarkMode,
    );
    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle:
          isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      elevation: 0,
    );
  }
}

class _Body extends StatelessWidget {
  const _Body();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const [
            _Logo(),
            InitialHomeAnimatedFormCard(
              child: InitialHomeAnimatedForms(),
            ),
          ],
        ),
        const InitialHomeColorModeIcon(),
      ],
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

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
