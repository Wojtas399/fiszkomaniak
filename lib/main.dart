import 'package:fiszkomaniak/config/theme/global_theme.dart';
import 'package:fiszkomaniak/features/initial_home/initial_home.dart';
import 'package:fiszkomaniak/global_providers.dart';
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
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return GlobalProviders(
          child: MaterialApp(
            title: 'Fiszkomaniak',
            themeMode: themeProvider.themeMode,
            theme: GlobalTheme.lightTheme,
            darkTheme: GlobalTheme.darkTheme,
            navigatorKey: navigatorKey,
            home: const InitialHome(),
          ),
        );
      },
    );
  }
}
