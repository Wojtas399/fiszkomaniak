import 'package:fiszkomaniak/features/home/listeners/appearance_settings_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/courses_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/flashcards_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/groups_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/sessions_bloc_listener.dart';
import 'package:fiszkomaniak/features/home/listeners/user_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;
  final PageController pageController;
  final Dialogs dialogs = Dialogs();

  HomeListeners({
    Key? key,
    required this.child,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        UserBlocListener(),
        AppearanceSettingsBlocListener(),
        CoursesBlocListener(onHomePageChanged: _animateToPage),
        GroupsBlocListener(onHomePageChanged: _animateToPage),
        FlashcardsBlocListener(),
        SessionsBlocListener(onHomePageChanged: _animateToPage),
      ],
      child: child,
    );
  }

  void _animateToPage(int pageNumber) {
    pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}
