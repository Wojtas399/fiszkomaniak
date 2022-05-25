import 'package:fiszkomaniak/config/navigation.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/local_notifications/local_notifications_bloc.dart';

class NotificationsListener
    extends BlocListener<LocalNotificationsBloc, LocalNotificationsState> {
  NotificationsListener({super.key})
      : super(
          listener: (BuildContext context, LocalNotificationsState state) {
            if (state is LocalNotificationsStateSessionSelected) {
              context.read<Navigation>().navigateToSessionPreview(
                    SessionPreviewModeNormal(sessionId: state.sessionId),
                  );
            }
          },
        );
}
