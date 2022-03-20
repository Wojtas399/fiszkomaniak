import 'package:fiszkomaniak/config/keys.dart';
import 'package:fiszkomaniak/config/theme/global_theme.dart';
import 'package:fiszkomaniak/features/initial_home/initial_home.dart';
import 'package:fiszkomaniak/providers/auth/auth_bloc_provider.dart';
import 'package:fiszkomaniak/providers/auth/auth_interface_provider.dart';
import 'package:fiszkomaniak/providers/settings/settings_interface_provider.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return AuthInterfaceProvider(
          child: SettingsInterfaceProvider(
            child: AuthBlocProvider(
              child: MaterialApp(
                title: 'Fiszkomaniak',
                themeMode: themeProvider.themeMode,
                theme: GlobalTheme.lightTheme,
                darkTheme: GlobalTheme.darkTheme,
                navigatorKey: Keys.navigatorKey,
                home: const InitialHome(),
              ),
            ),
          ),
        );
      },
    );
  }
}
