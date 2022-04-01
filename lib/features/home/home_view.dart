import 'package:fiszkomaniak/features/account/account_page.dart';
import 'package:fiszkomaniak/features/courses_library/courses_library_page.dart';
import 'package:fiszkomaniak/features/home/components/home_app_bar.dart';
import 'package:fiszkomaniak/features/home/components/home_bottom_navigation_bar.dart';
import 'package:fiszkomaniak/features/home/home_listeners.dart';
import 'package:fiszkomaniak/features/sessions/sessions_page.dart';
import 'package:fiszkomaniak/features/study/study_page.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'components/home_action_button.dart';

class HomeView extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  final _displayingPageNumber = BehaviorSubject<int>();

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HomeListeners(
      pageController: _pageController,
      child: StreamBuilder(
        stream: _displayingPageNumber,
        builder: (_, AsyncSnapshot<int> snapshot) {
          int displayingPageNumber = snapshot.data ?? 0;
          return Scaffold(
            extendBody: true,
            appBar: HomeAppBar(displayingPageNumber: displayingPageNumber),
            body: PageView(
              controller: _pageController,
              onPageChanged: (int number) {
                _displayingPageNumber.add(number);
              },
              children: const [
                StudyPage(),
                SessionsPage(),
                CoursesLibraryPage(),
                AccountPage(),
              ],
            ),
            floatingActionButton: const HomeActionButton(),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: HomeBottomNavigationBar(
              pageController: _pageController,
              displayingPageNumber: displayingPageNumber,
            ),
          );
        },
      ),
    );
  }
}
