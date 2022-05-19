import 'package:fiszkomaniak/features/home/home_providers.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const HomeProviders(
        child: HomeRouter(),
      ),
    );
  }
}
