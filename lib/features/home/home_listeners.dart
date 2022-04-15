import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/courses/courses_status.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../core/appearance_settings/appearance_settings_bloc.dart';
import '../../core/appearance_settings/appearance_settings_state.dart';
import '../../core/groups/groups_status.dart';
import '../../providers/theme_provider.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;
  final PageController pageController;

  const HomeListeners({
    Key? key,
    required this.child,
    required this.pageController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Dialogs dialogs = Dialogs();
    return MultiBlocListener(
      listeners: [
        BlocListener<AppearanceSettingsBloc, AppearanceSettingsState>(
          listener: (BuildContext context, AppearanceSettingsState state) {
            final ThemeProvider themeProvider = context.read<ThemeProvider>();
            if (state.isDarkModeCompatibilityWithSystemOn) {
              themeProvider.setSystemTheme();
            } else {
              themeProvider.toggleTheme(state.isDarkModeOn);
            }
          },
        ),
        BlocListener<CoursesBloc, CoursesState>(
          listener: (BuildContext context, CoursesState state) {
            final CoursesStatus status = state.status;
            if (status is CoursesStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is CoursesStatusCourseAdded) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigation.backHome();
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nowy kurs');
              _animateToPage(2);
            } else if (status is CoursesStatusCourseUpdated) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigation.backHome();
              dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano kurs');
            } else if (status is CoursesStatusCourseRemoved) {
              Navigator.of(context, rootNavigator: true).pop();
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto kurs');
            } else if (status is CoursesStatusError) {
              Navigator.of(context, rootNavigator: true).pop();
              dialogs.showDialogWithMessage(
                title: 'Wystąpił błąd...',
                message: status.message,
              );
            }
          },
        ),
        BlocListener<GroupsBloc, GroupsState>(
          listener: (BuildContext context, GroupsState state) {
            final GroupsStatus status = state.status;
            if (status is GroupsStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is GroupsStatusGroupAdded) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigation.backHome();
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nową grupę');
              _animateToPage(0);
            } else if (status is GroupsStatusGroupUpdated) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
              dialogs.showSnackbarWithMessage(
                'Pomyślnie zaktualizowano grupę',
              );
            } else if (status is GroupsStatusGroupRemoved) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigation.backHome();
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto grupę');
            } else if (status is GroupsStatusError) {
              Navigator.of(context, rootNavigator: true).pop();
              dialogs.showDialogWithMessage(
                title: 'Wystąpił błąd...',
                message: status.message,
              );
            }
          },
        ),
        BlocListener<FlashcardsBloc, FlashcardsState>(
          listener: (BuildContext context, FlashcardsState state) {
            final FlashcardsStatus status = state.status;
            if (status is FlashcardsStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is FlashcardsStatusFlashcardsAdded) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).pop();
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nowe fiszki');
            } else if (status is FlashcardsStatusFlashcardsSaved) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).pop();
              dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusError) {
              Navigator.of(context, rootNavigator: true).pop();
              dialogs.showDialogWithMessage(
                title: 'Wystąpił błąd...',
                message: status.message,
              );
            }
          },
        )
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
