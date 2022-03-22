import 'package:fiszkomaniak/config/app_router.dart';
import 'package:fiszkomaniak/features/home/home_providers.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const HomeProviders(
      child: Navigator(
        onGenerateRoute: AppRouter.generateRoute,
        initialRoute: AppRouter.home,
      ),
    );
  }
}
