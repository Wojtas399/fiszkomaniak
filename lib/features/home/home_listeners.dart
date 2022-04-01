import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../core/appearance_settings/appearance_settings_bloc.dart';
import '../../core/appearance_settings/appearance_settings_state.dart';
import '../../core/groups/groups_status.dart';
import '../../models/http_status_model.dart';
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
            HttpStatus status = state.httpStatus;
            if (status is HttpStatusSubmitting) {
              dialogs.showLoadingDialog();
            } else if (status is HttpStatusSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigation.backHome();
              final String? message = status.message;
              if (message != null) {
                dialogs.showSnackbarWithMessage(message);
              }
            } else if (status is HttpStatusFailure) {
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
              dialogs.showSnackbarWithMessage('Pomyślnie dodano nową grupę.');
              pageController.animateToPage(
                0,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
              );
            } else if (status is GroupsStatusGroupUpdated) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.pop(context);
              dialogs.showSnackbarWithMessage(
                'Pomyślnie zaktualizowano grupę.',
              );
            } else if (status is GroupsStatusGroupRemoved) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigation.backHome();
              dialogs.showSnackbarWithMessage('Pomyślnie usunięto grupę.');
            } else if (status is GroupsStatusError) {
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
}
