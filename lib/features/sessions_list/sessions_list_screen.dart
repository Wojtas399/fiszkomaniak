import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../components/empty_content_info.dart';
import '../../components/list_view_fade_animated_item.dart';
import '../../domain/entities/course.dart';
import '../../domain/entities/group.dart';
import '../../domain/entities/session.dart';
import '../../domain/use_cases/courses/get_course_use_case.dart';
import '../../domain/use_cases/groups/get_group_use_case.dart';
import '../../domain/use_cases/sessions/get_all_sessions_use_case.dart';
import '../../interfaces/courses_interface.dart';
import '../../interfaces/groups_interface.dart';
import '../../interfaces/sessions_interface.dart';
import '../../models/date_model.dart';
import '../../models/time_model.dart';
import '../../utils/sessions_utils.dart';
import 'sessions_list_item.dart';

class SessionsListScreen extends StatelessWidget {
  const SessionsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetAllSessionsUseCase(
        sessionsInterface: context.read<SessionsInterface>(),
      ).execute(),
      builder: (_, AsyncSnapshot<List<Session>> snapshot) {
        final List<Session>? allSessions = snapshot.data;
        if (allSessions != null && allSessions.isNotEmpty) {
          return _AllSessionsList(allSessions: allSessions);
        }
        return const _InfoAboutLackOfSessions();
      },
    );
  }
}

class _AllSessionsList extends StatelessWidget {
  final List<Session> allSessions;
  final SessionsUtils _sessionsUtils = SessionsUtils();

  _AllSessionsList({required this.allSessions});

  @override
  Widget build(BuildContext context) {
    final List<Session> allSessions =
        _sessionsUtils.setSessionsFromFirstToLastByStartTime(this.allSessions);

    return ListView.builder(
      padding: const EdgeInsets.only(
        top: 16,
        right: 16,
        bottom: 100,
        left: 16,
      ),
      cacheExtent: 0,
      itemCount: allSessions.length,
      itemBuilder: (_, int index) {
        final Session session = allSessions[index];

        return ListViewFadeAnimatedItem(
          child: _SessionItem(
            sessionId: session.id,
            date: session.date,
            startTime: session.startTime,
            duration: session.duration,
            groupId: session.groupId,
          ),
        );
      },
    );
  }
}

class _InfoAboutLackOfSessions extends StatelessWidget {
  const _InfoAboutLackOfSessions();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: EmptyContentInfo(
        icon: MdiIcons.calendarCheck,
        title: 'Brak sesji',
        subtitle:
            'Naciśnij fioletowy przycisk u dołu ekranu aby utworzyć nowe sesje',
      ),
    );
  }
}

class _SessionItem extends StatelessWidget {
  final String sessionId;
  final Date date;
  final Time startTime;
  final Duration? duration;
  final String groupId;

  const _SessionItem({
    required this.sessionId,
    required this.date,
    required this.startTime,
    required this.duration,
    required this.groupId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: GetGroupUseCase(
        groupsInterface: context.read<GroupsInterface>(),
      ).execute(groupId: groupId),
      builder: (_, AsyncSnapshot<Group> snapshot) {
        final Group? group = snapshot.data;
        if (group == null) {
          return const Text('Cannot load group');
        }
        return StreamBuilder(
          stream: GetCourseUseCase(
            coursesInterface: context.read<CoursesInterface>(),
          ).execute(courseId: group.courseId),
          builder: (_, AsyncSnapshot<Course> courseSnapshot) {
            return SessionsListItem(
              sessionId: sessionId,
              date: date,
              startTime: startTime,
              duration: duration,
              groupName: group.name,
              courseName: courseSnapshot.data?.name ?? '',
            );
          },
        );
      },
    );
  }
}
