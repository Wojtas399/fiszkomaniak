import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'config/theme/global_theme.dart';
import 'features/initial_home/initial_home.dart';
import 'global_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => ThemeProvider(),
      builder: (BuildContext context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return GlobalProvider(
          child: MaterialApp(
            title: 'Fiszkomaniak',
            themeMode: themeProvider.themeMode,
            theme: GlobalTheme.lightTheme,
            darkTheme: GlobalTheme.darkTheme,
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [Locale('pl', 'PL')],
            home: const InitialHome(),
          ),
        );
      },
    );
  }
}
