import 'package:fiszkomaniak/features/initial_home/components/animated_form_card.dart';
import 'package:fiszkomaniak/features/initial_home/components/animated_forms.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/utils/utils.dart';
import 'package:flutter/material.dart';
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
        resizeToAvoidBottomInset: false,
        body: ChangeNotifierProvider(
          create: (_) => InitialHomeModeProvider(),
          builder: (context, _) {
            return Stack(
              children: [
                Column(
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
          },
        ),
      ),
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
