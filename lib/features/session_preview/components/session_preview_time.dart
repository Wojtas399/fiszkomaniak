import 'package:fiszkomaniak/components/custom_icon_button.dart';
import 'package:fiszkomaniak/components/time_picker.dart';
import 'package:fiszkomaniak/converters/time_converter.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_bloc.dart';
import 'package:fiszkomaniak/features/session_preview/bloc/session_preview_state.dart';
import 'package:fiszkomaniak/models/session_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class SessionPreviewTime extends StatelessWidget {
  const SessionPreviewTime({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionPreviewBloc, SessionPreviewState>(
      builder: (BuildContext context, SessionPreviewState state) {
        final Session? session = state.session;
        if (session == null) {
          return const SizedBox();
        }
        return Column(
          children: [
            TimePicker(
              icon: MdiIcons.clockStart,
              label: 'Godzina rozpoczęcia',
              value: convertTimeToViewFormat(session.time),
              initialTime: session.time,
              paddingLeft: 8.0,
              paddingRight: 8.0,
            ),
            Stack(
              children: [
                TimePicker(
                  icon: MdiIcons.clockOutline,
                  label: 'Czas trwania',
                  value: convertTimeToDurationViewFormat(session.duration),
                  initialTime: session.duration,
                  paddingLeft: 8.0,
                  paddingRight: 8.0,
                ),
                Positioned(
                  right: 0.0,
                  bottom: 8.0,
                  child: CustomIconButton(
                    icon: MdiIcons.close,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            Stack(
              children: [
                TimePicker(
                  icon: MdiIcons.bellRingOutline,
                  label: 'Godzina przypomnienia',
                  value: convertTimeToViewFormat(session.notificationTime),
                  initialTime: session.notificationTime,
                  paddingLeft: 8.0,
                  paddingRight: 8.0,
                ),
                Positioned(
                  right: 0.0,
                  bottom: 8.0,
                  child: CustomIconButton(
                    icon: MdiIcons.close,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
