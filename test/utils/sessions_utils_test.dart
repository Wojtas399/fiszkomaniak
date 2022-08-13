import 'package:flutter_test/flutter_test.dart';
import 'package:fiszkomaniak/models/time_model.dart';
import 'package:fiszkomaniak/models/date_model.dart';
import 'package:fiszkomaniak/domain/entities/session.dart';
import 'package:fiszkomaniak/utils/sessions_utils.dart';

void main() {
  final SessionsUtils utils = SessionsUtils();

  group(
    'set sessions from first to last by start time',
    () {
      test(
        'should compare sessions by date if they have different dates',
        () {
          final List<Session> sessionsInRandomOrder = [
            createSession(
              id: 's1',
              date: const Date(year: 2022, month: 5, day: 5),
            ),
            createSession(
              id: 's2',
              date: const Date(year: 2022, month: 5, day: 2),
            ),
            createSession(
              id: 's3',
              date: const Date(year: 2022, month: 5, day: 3),
            ),
          ];
          final List<Session> sessionsInExpectedOrder = [
            sessionsInRandomOrder[1],
            sessionsInRandomOrder[2],
            sessionsInRandomOrder[0],
          ];

          final List<Session> sessions = utils
              .setSessionsFromFirstToLastByStartTime(sessionsInRandomOrder);

          expect(sessions, sessionsInExpectedOrder);
        },
      );

      test(
        'should compare sessions by start time if they have the same date',
        () {
          final List<Session> sessionsInRandomOrder = [
            createSession(
              id: 's1',
              date: const Date(year: 2022, month: 5, day: 5),
              startTime: const Time(hour: 17, minute: 30),
            ),
            createSession(
              id: 's2',
              date: const Date(year: 2022, month: 5, day: 3),
              startTime: const Time(hour: 17, minute: 30),
            ),
            createSession(
              id: 's3',
              date: const Date(year: 2022, month: 5, day: 5),
              startTime: const Time(hour: 20, minute: 0),
            ),
            createSession(
              id: 's4',
              date: const Date(year: 2022, month: 5, day: 5),
              startTime: const Time(hour: 15, minute: 45),
            ),
          ];
          final List<Session> sessionsInExpectedOrder = [
            sessionsInRandomOrder[1],
            sessionsInRandomOrder[3],
            sessionsInRandomOrder[0],
            sessionsInRandomOrder[2],
          ];

          final List<Session> sessions = utils
              .setSessionsFromFirstToLastByStartTime(sessionsInRandomOrder);

          expect(sessions, sessionsInExpectedOrder);
        },
      );

      test(
        'should not change order if sessions have the same date and start time',
        () {
          final List<Session> sessionsInRandomOrder = [
            createSession(
              id: 's1',
              date: const Date(year: 2022, month: 2, day: 2),
              startTime: const Time(hour: 12, minute: 30),
            ),
            createSession(
              id: 's2',
              date: const Date(year: 2022, month: 2, day: 2),
              startTime: const Time(hour: 12, minute: 30),
            ),
          ];
          final List<Session> sessionsInExpectedOrder = sessionsInRandomOrder;

          final List<Session> sessions = utils
              .setSessionsFromFirstToLastByStartTime(sessionsInRandomOrder);

          expect(sessions, sessionsInExpectedOrder);
        },
      );
    },
  );
}
