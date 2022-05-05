import 'package:fiszkomaniak/components/bouncing_scroll.dart';
import 'package:fiszkomaniak/components/empty_content_info.dart';
import 'package:fiszkomaniak/core/courses/courses_bloc.dart';
import 'package:fiszkomaniak/core/courses/courses_state.dart';
import 'package:fiszkomaniak/core/groups/groups_bloc.dart';
import 'package:fiszkomaniak/core/groups/groups_state.dart';
import 'package:fiszkomaniak/core/sessions/sessions_bloc.dart';
import 'package:fiszkomaniak/features/sessions_list/components/session_item.dart';
import 'package:fiszkomaniak/models/group_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../../core/sessions/sessions_state.dart';
import '../../models/session_model.dart';

class SessionsListPage extends StatelessWidget {
  const SessionsListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesBloc, CoursesState>(
      builder: (_, CoursesState coursesState) {
        return BlocBuilder<GroupsBloc, GroupsState>(
          builder: (_, GroupsState groupsState) {
            return BlocBuilder<SessionsBloc, SessionsState>(
              builder: (BuildContext context, SessionsState sessionsState) {
                if (sessionsState.allSessions.isEmpty) {
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
                        children: sessionsState.allSessions
                            .map(
                              (session) => _buildSessionItem(
                                session,
                                coursesState,
                                groupsState,
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildSessionItem(
    Session session,
    CoursesState coursesState,
    GroupsState groupsState,
  ) {
    final Group? group = groupsState.getGroupById(session.groupId);
    final String? courseName = coursesState.getCourseNameById(group?.courseId);
    return SessionItem(
      session: session,
      groupName: group?.name ?? '--',
      courseName: courseName ?? '--',
    );
  }
}