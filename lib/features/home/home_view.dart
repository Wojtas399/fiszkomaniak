import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../courses_library/courses_library_screen.dart';
import '../sessions_list/sessions_list_screen.dart';
import '../study/study_screen.dart';
import '../profile/profile_screen.dart';
import 'components/home_app_bar.dart';
import 'components/home_bottom_navigation_bar.dart';
import 'components/home_action_button.dart';
import 'home_listeners.dart';
import 'home.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeListeners(
      child: const Scaffold(
        extendBody: true,
        appBar: HomeAppBar(),
        body: _PageView(),
        floatingActionButton: HomeActionButton(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: HomeBottomNavigationBar(),
      ),
    );
  }
}

class _PageView extends StatelessWidget {
  const _PageView();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: context.read<HomePageController>().controller,
      children: const [
        StudyScreen(),
        SessionsListScreen(),
        CoursesLibraryScreen(),
        ProfileScreen(),
      ],
    );
  }
}
