import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/notifications/notifications_bloc.dart';

class NotificationsListener
    extends BlocListener<NotificationsBloc, NotificationsState> {
  NotificationsListener({super.key})
      : super(
          listener: (BuildContext context, NotificationsState state) {
            void _closeLoadingDialog() {
              Navigator.of(context, rootNavigator: true).pop();
            }

            if (state is NotificationsStateSessionSelected) {
              context.read<Navigation>().navigateToSessionPreview(
                    SessionPreviewModeNormal(sessionId: state.sessionId),
                  );
            } else if (state is NotificationsStateError) {
              if (Dialogs.isLoadingDialogOpened) {
                _closeLoadingDialog();
              }
              Dialogs.showErrorDialog(message: state.message);
            }
          },
        );
}
