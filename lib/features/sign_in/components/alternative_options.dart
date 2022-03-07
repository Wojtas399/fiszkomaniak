import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlternativeOptions extends StatelessWidget {
  const AlternativeOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    InitialHomeModeProvider initialHomeModeProvider =
        Provider.of<InitialHomeModeProvider>(context);
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              initialHomeModeProvider.changeMode(InitialHomeMode.register);
              _closeKeyboardIfIsOpened();
            },
            child: Text('Nie masz konta? Zarejestruj się!', style: _textStyle),
          ),
          const SizedBox(height: 16),
          Text('Zapomniałeś hasła?', style: _textStyle),
        ],
      ),
    );
  }

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
  );

  void _closeKeyboardIfIsOpened() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
