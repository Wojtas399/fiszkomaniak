import 'package:fiszkomaniak/injections/memory_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsStorageInterfaceProvider extends StatelessWidget {
  final Widget child;

  const SettingsStorageInterfaceProvider({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) =>
          MemoryStorageProvider.provideAppearanceSettingsStorageInterface(),
      child: child,
    );
  }
}
