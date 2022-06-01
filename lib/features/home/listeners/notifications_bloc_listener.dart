import 'package:fiszkomaniak/components/dialogs/dialogs.dart';
import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/notifications/notifications_bloc.dart';

class NotificationsBlocListener
    extends BlocListener<NotificationsBloc, NotificationsState> {
  NotificationsBlocListener({super.key})
      : super(
          listener: (BuildContext context, NotificationsState state) {
            final NotificationsStatus status = state.status;
            if (status is NotificationsStatusSessionSelected) {
              context.read<Navigation>().navigateToSessionPreview(
                    SessionPreviewModeNormal(sessionId: status.sessionId),
                  );
            } else if (status is NotificationsStatusError) {
              Dialogs.closeLoadingDialog(context);
              Dialogs.showErrorDialog(message: status.message);
            }
          },
        );
}
