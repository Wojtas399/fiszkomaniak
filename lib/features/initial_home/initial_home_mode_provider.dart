import 'package:flutter/material.dart';

enum InitialHomeMode {
  login,
  register,
}

class InitialHomeModeProvider extends ChangeNotifier {
  InitialHomeMode _mode = InitialHomeMode.login;

  bool get isLoginMode => _mode == InitialHomeMode.login;

  bool get isRegisterMode => _mode == InitialHomeMode.register;

  changeMode(InitialHomeMode newMode) {
    _mode = newMode;
    notifyListeners();
  }
}
