import '../domain/entities/session.dart';
import 'date_utils.dart';
import 'time_utils.dart';

class SessionsUtils {
  final DateUtils _dateUtils = DateUtils();
  final TimeUtils _timeUtils = TimeUtils();

  List<Session> setSessionsFromFirstToLastByStartTime(
    List<Session> sessions,
  ) {
    final List<Session> sortedSessions = [...sessions];
    sortedSessions.sort(_compareSessionsByDateAndTime);
    return sortedSessions;
  }

  int _compareSessionsByDateAndTime(
    Session session1,
    Session session2,
  ) {
    final int dateComparison = _dateUtils.compareDates(
      session1.date,
      session2.date,
    );
    if (dateComparison != 0) {
      return dateComparison;
    }
    return _timeUtils.compareTimes(
      session1.startTime,
      session2.startTime,
    );
  }
}
