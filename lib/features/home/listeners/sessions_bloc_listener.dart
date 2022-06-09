import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionsBlocListener extends BlocListener<SessionsBloc, SessionsState> {
  final Function(int pageIndex) onHomePageChanged;

  SessionsBlocListener({
    Key? key,
    required this.onHomePageChanged,
  }) : super(
          key: key,
          listener: (BuildContext context, SessionsState state) {
            final SessionsStatus status = state.status;
            if (status is SessionsStatusLoading) {
              Dialogs.showLoadingDialog();
            } else if (status is SessionsStatusSessionAdded) {
              Dialogs.closeLoadingDialog(context);
              context.read<Navigation>().backHome();
              Dialogs.showSnackbarWithMessage('Pomyślnie dodano nową sesję');
              onHomePageChanged(1);
            } else if (status is SessionsStatusSessionUpdated) {
              Dialogs.closeLoadingDialog(context);
              Navigator.pop(context);
              Dialogs.showSnackbarWithMessage('Pomyślnie zaktualizowano sesję');
            } else if (status is SessionsStatusSessionRemoved) {
              Dialogs.closeLoadingDialog(context);
              context.read<Navigation>().backHome();
              if (!status.hasSessionBeenRemovedAfterLearningProcess) {
                Dialogs.showSnackbarWithMessage('Pomyślnie usunięto sesję');
              }
            } else if (status is SessionsStatusError) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
