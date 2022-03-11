import 'package:fiszkomaniak/features/initial_home/components/animated_form_card.dart';
import 'package:fiszkomaniak/features/initial_home/components/animated_forms.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'color_mode_icon.dart';

class InitialHomeView extends StatelessWidget {
  const InitialHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Utils.unfocusElements();
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: _AppBar(),
        ),
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

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

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
