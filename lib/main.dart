import 'package:fiszkomaniak/config/theme/global_theme.dart';
import 'package:fiszkomaniak/features/initial_home/initial_home.dart';
import 'package:fiszkomaniak/global_interfaces_provider.dart';
import 'package:fiszkomaniak/providers/auth_bloc_provider.dart';
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
        return GlobalInterfacesProvider(
          child: MaterialApp(
            title: 'Fiszkomaniak',
            themeMode: themeProvider.themeMode,
            theme: GlobalTheme.lightTheme,
            darkTheme: GlobalTheme.darkTheme,
            home: const AuthBlocProvider(
              child: InitialHome(),
            ),
          ),
        );
      },
    );
  }
}
