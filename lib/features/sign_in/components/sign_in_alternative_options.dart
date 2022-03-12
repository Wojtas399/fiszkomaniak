import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/reset_password/reset_password_page.dart';
import 'package:fiszkomaniak/providers/initial_home_mode_provider.dart';
import 'package:fiszkomaniak/utils/utils.dart';
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
              Utils.unfocusElements();
            },
            child: Text('Nie masz konta? Zarejestruj się!', style: _textStyle),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              Navigation.navigateToPage(context, const ResetPasswordPage());
            },
            child: Text('Zapomniałeś hasła?', style: _textStyle),
          ),
        ],
      ),
    );
  }

  final TextStyle _textStyle = const TextStyle(
    color: Colors.black,
    fontSize: 12,
  );
}
