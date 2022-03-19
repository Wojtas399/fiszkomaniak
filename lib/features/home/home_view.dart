import 'package:fiszkomaniak/features/account/account_page.dart';
import 'package:fiszkomaniak/features/courses/courses_page.dart';
import 'package:fiszkomaniak/features/home/components/home_app_bar.dart';
import 'package:fiszkomaniak/features/home/components/home_bottom_navigation_bar.dart';
import 'package:fiszkomaniak/features/sessions/sessions_page.dart';
import 'package:fiszkomaniak/features/study/study_page.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:rxdart/rxdart.dart';

class HomeView extends StatelessWidget {
  final PageController _pageController = PageController(initialPage: 0);
  final _displayingPageNumber = BehaviorSubject<int>();

  HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _displayingPageNumber,
      builder: (_, AsyncSnapshot<int> snapshot) {
        int displayingPageNumber = snapshot.data ?? 0;
        return Scaffold(
          appBar: HomeAppBar(displayingPageNumber: displayingPageNumber),
          body: PageView(
            controller: _pageController,
            onPageChanged: (int number) {
              _displayingPageNumber.add(number);
            },
            children: const [
              StudyPage(),
              SessionsPage(),
              CoursesPage(),
              AccountPage(),
            ],
          ),
          floatingActionButton: const _ActionButton(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: HomeBottomNavigationBar(
            pageController: _pageController,
            displayingPageNumber: displayingPageNumber,
          ),
        );
      },
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 74.0,
      width: 74.0,
      child: FittedBox(
        child: FloatingActionButton(
          onPressed: () {},
          child: const Icon(MdiIcons.plus),
        ),
      ),
    );
  }
}
