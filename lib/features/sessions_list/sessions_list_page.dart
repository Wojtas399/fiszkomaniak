import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/features/sessions_list/components/session_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../domain/entities/session.dart';

class SessionsListPage extends StatelessWidget {
  const SessionsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (false) {
      return const SafeArea(
        child: EmptyContentInfo(
          icon: MdiIcons.calendarCheck,
          title: 'Brak sesji',
          subtitle:
              'Naciśnij fioletowy przycisk u dołu ekranu aby utworzyć nowe sesje',
        ),
      );
    }
    return BouncingScroll(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 16,
            right: 16,
            bottom: 32,
            left: 16,
          ),
          child: Column(
            children: []
                .map(
                  (session) => _buildSessionItem(session),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildSessionItem(
    Session session,
  ) {
    // final Group? group = groupsState.getGroupById(session.groupId);
    const String courseName = 'NIE WIEM';
    return SessionItem(
      session: session,
      groupName: '--',
      courseName: courseName,
    );
  }
}
