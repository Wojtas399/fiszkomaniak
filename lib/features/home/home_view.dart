import 'package:fiszkomaniak/features/courses_library/courses_library_page.dart';
import 'package:fiszkomaniak/features/home/components/home_app_bar.dart';
import 'package:fiszkomaniak/features/home/components/home_bottom_navigation_bar.dart';
import 'package:fiszkomaniak/features/home/home_listeners.dart';
import 'package:fiszkomaniak/features/sessions_list/sessions_list_page.dart';
import 'package:fiszkomaniak/features/study/study_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../profile/profile_page.dart';
import 'components/home_action_button.dart';
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
        StudyPage(),
        SessionsListPage(),
        CoursesLibraryPage(),
        ProfilePage(),
      ],
    );
  }
}
