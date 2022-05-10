import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/courses/courses_status.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_bloc.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_state.dart';
import 'package:fiszkomaniak/core/flashcards/flashcards_status.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/core/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../core/appearance_settings/appearance_settings_bloc.dart';
import '../../core/appearance_settings/appearance_settings_state.dart';
import '../../core/groups/groups_status.dart';
import '../../core/sessions/sessions_state.dart';
import '../../core/sessions/sessions_status.dart';
import '../../providers/theme_provider.dart';

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
        BlocListener<UserBloc, UserState>(
          listener: (BuildContext context, UserState state) {
            final UserStatus status = state.status;
            if (status is UserStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is UserStatusNewAvatarSaved) {
              _closeLoadingDialog(context);
              dialogs.showSnackbarWithMessage(
                'Pomyślnie zapisano nowe zdjęcie profilowe',
              );
            } else if (status is UserStatusAvatarRemoved) {
              _closeLoadingDialog(context);
              dialogs.showSnackbarWithMessage(
                'Pomyślnie usunięto zdjęcie profilowe',
              );
            } else if (status is UserStatusNewRememberedFlashcardsSaved) {
              _closeLoadingDialog(context);
              dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is UserStatusError) {
              _closeLoadingDialog(context);
              _displayError(status.message);
            }
          },
        ),
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
              _closeLoadingDialog(context);
              _backHome(context);
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nowy kurs');
              _animateToPage(2);
            } else if (status is CoursesStatusCourseUpdated) {
              _closeLoadingDialog(context);
              _backHome(context);
              dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano kurs');
            } else if (status is CoursesStatusCourseRemoved) {
              _closeLoadingDialog(context);
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto kurs');
            } else if (status is CoursesStatusError) {
              _closeLoadingDialog(context);
              _displayError(status.message);
            }
          },
        ),
        BlocListener<GroupsBloc, GroupsState>(
          listener: (BuildContext context, GroupsState state) {
            final GroupsStatus status = state.status;
            if (status is GroupsStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is GroupsStatusGroupAdded) {
              _closeLoadingDialog(context);
              _backHome(context);
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nową grupę');
              _animateToPage(0);
            } else if (status is GroupsStatusGroupUpdated) {
              _closeLoadingDialog(context);
              _moveBack(context);
              dialogs.showSnackbarWithMessage(
                'Pomyślnie zaktualizowano grupę',
              );
            } else if (status is GroupsStatusGroupRemoved) {
              _closeLoadingDialog(context);
              _backHome(context);
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto grupę');
            } else if (status is GroupsStatusError) {
              _closeLoadingDialog(context);
              _displayError(status.message);
            }
          },
        ),
        BlocListener<FlashcardsBloc, FlashcardsState>(
          listener: (BuildContext context, FlashcardsState state) {
            final FlashcardsStatus status = state.status;
            if (status is FlashcardsStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is FlashcardsStatusFlashcardsAdded) {
              _closeLoadingDialog(context);
              _moveBack(context);
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nowe fiszki');
            } else if (status is FlashcardsStatusFlashcardUpdated) {
              _closeLoadingDialog(context);
              dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusFlashcardRemoved) {
              _closeLoadingDialog(context);
              _moveBack(context);
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto fiszkę');
            } else if (status is FlashcardsStatusFlashcardsSaved) {
              _closeLoadingDialog(context);
              Navigator.of(context).pop();
              dialogs.showSnackbarWithMessage('Pomyślnie zapisano zmiany');
            } else if (status is FlashcardsStatusError) {
              _closeLoadingDialog(context);
              _displayError(status.message);
            }
          },
        ),
        BlocListener<SessionsBloc, SessionsState>(
          listener: (BuildContext context, SessionsState state) {
            final SessionsStatus status = state.status;
            if (status is SessionsStatusLoading) {
              dialogs.showLoadingDialog();
            } else if (status is SessionsStatusSessionAdded) {
              _closeLoadingDialog(context);
              _backHome(context);
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nową sesję');
              _animateToPage(1);
            } else if (status is SessionsStatusSessionUpdated) {
              _closeLoadingDialog(context);
              _moveBack(context);
              dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano sesję');
            } else if (status is SessionsStatusSessionRemoved) {
              _closeLoadingDialog(context);
              _backHome(context);
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto sesję');
            } else if (status is SessionsStatusError) {
              _closeLoadingDialog(context);
              _displayError(status.message);
            }
          },
        ),
      ],
      child: child,
    );
  }

  void _displayError(String message) {
    dialogs.showDialogWithMessage(
      title: 'Wystąpił błąd...',
      message: message,
    );
  }

  void _animateToPage(int pageNumber) {
    pageController.animateToPage(
      pageNumber,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _closeLoadingDialog(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }

  void _moveBack(BuildContext context) {
    Navigator.pop(context);
  }

  void _backHome(BuildContext context) {
    context.read<Navigation>().backHome();
  }
}
