import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:fiszkomaniak/domain/entities/course.dart';
import 'package:fiszkomaniak/domain/entities/group.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/domain/use_cases/courses/get_course_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/groups/get_group_use_case.dart';
import 'package:fiszkomaniak/domain/use_cases/sessions/get_all_sessions_use_case.dart';
import 'package:fiszkomaniak/features/sessions_list/sessions_list_cubit.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/models/time_model.dart';

class MockGetAllSessionsUseCase extends Mock implements GetAllSessionsUseCase {}

class MockGetGroupUseCase extends Mock implements GetGroupUseCase {}

class MockGetCourseUseCase extends Mock implements GetCourseUseCase {}

void main() {
  final getAllSessionsUseCase = MockGetAllSessionsUseCase();
  final getGroupUseCase = MockGetGroupUseCase();
  final getCourseUseCase = MockGetCourseUseCase();

  SessionsListCubit createCubit() {
    return SessionsListCubit(
      getAllSessionsUseCase: getAllSessionsUseCase,
      getGroupUseCase: getGroupUseCase,
      getCourseUseCase: getCourseUseCase,
    );
  }

  tearDown(() {
    reset(getAllSessionsUseCase);
    reset(getGroupUseCase);
    reset(getCourseUseCase);
  });

  group(
    'initialize & sessions items params updated',
    () {
      final List<Session> allSessions = [
        createSession(
          id: 's1',
          groupId: 'g1',
          date: const Date(year: 2022, month: 1, day: 1),
          startTime: const Time(hour: 10, minute: 0),
          duration: const Duration(minutes: 30),
        ),
        createSession(
          id: 's2',
          groupId: 'g2',
          date: const Date(year: 2022, month: 2, day: 2),
          startTime: const Time(hour: 12, minute: 30),
          duration: null,
        ),
      ];
      final Group group1 = createGroup(
        id: 'g1',
        courseId: 'c1',
        name: 'group1',
      );
      final Group group2 = createGroup(
        id: 'g2',
        courseId: 'c1',
        name: 'group2',
      );
      final Course course = createCourse(id: 'c1', name: 'course1');

      blocTest(
        'should set sessions items params listener',
        build: () => createCubit(),
        setUp: () {
          when(
            () => getAllSessionsUseCase.execute(),
          ).thenAnswer((_) => Stream.value(allSessions));
          when(
            () => getGroupUseCase.execute(groupId: 'g1'),
          ).thenAnswer((_) => Stream.value(group1));
          when(
            () => getGroupUseCase.execute(groupId: 'g2'),
          ).thenAnswer((_) => Stream.value(group2));
          when(
            () => getCourseUseCase.execute(courseId: 'c1'),
          ).thenAnswer((_) => Stream.value(course));
        },
        act: (SessionsListCubit cubit) {
          cubit.initialize();
        },
        expect: () => [
          [
            SessionItemParams(
              sessionId: allSessions[0].id,
              date: allSessions[0].date,
              startTime: allSessions[0].startTime,
              duration: allSessions[0].duration,
              groupName: group1.name,
              courseName: course.name,
            ),
            SessionItemParams(
              sessionId: allSessions[1].id,
              date: allSessions[1].date,
              startTime: allSessions[1].startTime,
              duration: allSessions[1].duration,
              groupName: group2.name,
              courseName: course.name,
            ),
          ],
        ],
      );
    },
  );
}
