import 'package:fiszkomaniak/domain/use_cases/appearance_settings/get_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/appearance_settings/load_appearance_settings_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/load_all_groups_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/notifications_settings/load_notifications_settings_use_case.dart';
import 'package:fiszkomaniak/features/home/bloc/home_bloc.dart';
import 'package:fiszkomaniak/features/home/home_error_screen.dart';
import 'package:fiszkomaniak/features/home/home_loading_screen.dart';
import 'package:fiszkomaniak/features/home/home_providers.dart';
import 'package:fiszkomaniak/features/home/home_router.dart';
import 'package:fiszkomaniak/interfaces/appearance_settings_interface.dart';
import 'package:fiszkomaniak/interfaces/groups_interface.dart';
import 'package:fiszkomaniak/interfaces/notifications_settings_interface.dart';
import 'package:fiszkomaniak/interfaces/user_interface.dart';
import 'package:fiszkomaniak/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: const HomeProviders(
        child: _HomeBlocProvider(
          child: _HomeBlocListener(
            child: _View(),
          ),
        ),
      ),
    );
  }
}

class _HomeBlocProvider extends StatelessWidget {
  final Widget child;

  const _HomeBlocProvider({required this.child});

  @override
  Widget build(BuildContext context) {
    final AppearanceSettingsInterface appearanceSettingsInterface =
        context.read<AppearanceSettingsInterface>();
    return BlocProvider(
      create: (BuildContext context) => HomeBloc(
        userInterface: context.read<UserInterface>(),
        loadAllGroupsUseCase: LoadAllGroupsUseCase(
          groupsInterface: context.read<GroupsInterface>(),
        ),
        loadAppearanceSettingsUseCase: LoadAppearanceSettingsUseCase(
          appearanceSettingsInterface: appearanceSettingsInterface,
        ),
        loadNotificationsSettingsUseCase: LoadNotificationsSettingsUseCase(
          notificationsSettingsInterface:
              context.read<NotificationsSettingsInterface>(),
        ),
        getAppearanceSettingsUseCase: GetAppearanceSettingsUseCase(
          appearanceSettingsInterface: appearanceSettingsInterface,
        ),
      )..add(HomeEventInitialize()),
      child: child,
    );
  }
}

class _HomeBlocListener extends StatelessWidget {
  final Widget child;

  const _HomeBlocListener({required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (BuildContext context, HomeState state) {
        final bool isDarkModeOn = state.isDarkModeOn;
        final bool isDarkModeCompatibilityWithSystemOn =
            state.isDarkModeCompatibilityWithSystemOn;
        if (isDarkModeCompatibilityWithSystemOn) {
          context.read<ThemeProvider>().setSystemTheme();
        } else {
          context.read<ThemeProvider>().toggleTheme(isDarkModeOn);
        }
      },
      child: child,
    );
  }
}

class _View extends StatelessWidget {
  const _View();

  @override
  Widget build(BuildContext context) {
    final HomeStatus homeStatus = context.select(
      (HomeBloc bloc) => bloc.state.status,
    );
    if (homeStatus is HomeStatusLoading) {
      return const HomeLoadingScreen();
    } else if (homeStatus is HomeStatusLoaded) {
      return ChangeNotifierProvider(
        create: (_) => HomePageController(),
        child: const HomeRouter(),
      );
    }
    return const HomeErrorScreen();
  }
}

class HomePageController extends ChangeNotifier {
  final PageController _pageController = PageController(initialPage: 0);
  int pageNumber = 0;

  PageController get controller => _pageController;

  void moveToPage(int pageNumber) {
    _pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
    this.pageNumber = pageNumber;
    notifyListeners();
  }
}
