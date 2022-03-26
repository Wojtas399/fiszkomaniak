import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../components/dialogs/dialogs.dart';
import '../../core/appearance_settings/appearance_settings_bloc.dart';
import '../../core/appearance_settings/appearance_settings_state.dart';
import '../../models/http_status_model.dart';
import '../../providers/theme_provider.dart';

class HomeListeners extends StatelessWidget {
  final Widget child;

  const HomeListeners({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Dialogs.showLoadingDialog(context: context);
            } else if (status is HttpStatusSuccess) {
              Navigator.of(context, rootNavigator: true).pop();
              Navigator.of(context).popUntil(ModalRoute.withName('/'));
              final String? message = status.message;
              if (message != null) {
                Dialogs.showSnackbarWithMessage(
                  context: context,
                  message: message,
                );
              }
            } else if (status is HttpStatusFailure) {
              Navigator.of(context, rootNavigator: true).pop();
              Dialogs.showDialogWithMessage(
                context: context,
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
